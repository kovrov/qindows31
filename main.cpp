//
// Copyright (C) 2014, Robin Burchell <robin+git@viroteck.net>
//
// Originally transcribed from/helped by dewinfont, which was:
//  Copyright (C) 2001 Simon Tatham. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
// BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
// ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <QBitmap>
#include <QPainter>
#include <QFile>
#include <QDebug>
#include <QGuiApplication>
#include <QtEndian>
#include <QQuickView>

typedef uint16_t word_t;
typedef uint32_t dword_t;

namespace Word
{
    word_t fromIndex(const QByteArray &data, int idx)
    {
        return qFromLittleEndian<word_t>((const uchar *)data.constData() + idx);
    }
}

namespace DWord
{
    dword_t fromIndex(const QByteArray &data, int idx)
    {
        return Word::fromIndex(data, idx) | Word::fromIndex(data, idx + 2);
    }
}

struct Character
{
    word_t width;
    QVector<long> data;
};

struct Font
{
    QByteArray faceName;
    QByteArray copyright;
    word_t pointSize;
    word_t ascent;
    word_t height;
    int8_t italic;
    int8_t underline;
    int8_t strikeout;
    word_t weight;
    int8_t charset;
    QVector<Character> chars;

    void init()
    {
        for (int i = 0; i < 256; ++i) {
            Character c;
            c.width = 0;
            c.data.resize(height);
            chars.append(c);
        }
    }
};

Font dofnt(const QByteArray &fnt)
{
    Font fobj;
    word_t version = Word::fromIndex(fnt, 0);
    word_t ftype = Word::fromIndex(fnt, 0x42);
    if (ftype & 1) {
        qWarning() << "This font is a vector font!";
        return Font();
    }

    dword_t off_facename = DWord::fromIndex(fnt, 0x69);
    if (off_facename > (unsigned)fnt.size()) {
        qWarning() << "Face name not contained within font data";
        return Font();
    }

    fobj.faceName = QByteArray(fnt.constData() + off_facename);
    {
        QByteArray copyright = QByteArray(fnt.constData() + 6, 66);
        for (int i = 0; i < copyright.size(); ++i) { // read & truncate at the first null
            if (copyright.at(i) == '\0') {
                copyright.truncate(i);
                break;
            }
        }
        fobj.copyright = copyright;
    }
    fobj.pointSize = Word::fromIndex(fnt, 0x44);
    fobj.ascent = Word::fromIndex(fnt, 0x4a);
    fobj.height = Word::fromIndex(fnt, 0x58);
    fobj.italic = fnt.at(0x50);
    fobj.underline = fnt.at(0x51);
    fobj.strikeout = fnt.at(0x52);
    fobj.weight = fnt.at(0x53);
    fobj.charset = fnt.at(0x55);

    // now we have the font characteristics, set up the character data
    // fobj.characters is now valid after this
    fobj.init();

    const word_t ctstart = version == 0x200 ? 0x76 : 0x94;
    const word_t ctsize = version == 0x200 ? 4 : 6;

    uint8_t firstchar = fnt.at(0x5f);
    uint8_t lastchar = fnt.at(0x60);

    //qDebug() << "First char: " << firstchar << "Last char " << lastchar;
    for (int i = firstchar; i < lastchar + 1; ++i) {
        int16_t entry = ctstart + ctsize * (i - firstchar);
        word_t w = Word::fromIndex(fnt, entry);
        fobj.chars[i].width = w;
        dword_t off = ctsize == 4 ? Word::fromIndex(fnt, entry + 2) : DWord::fromIndex(fnt, entry + 2);
        word_t widthbytes = (w + 7) / 8;
        for (int j = 0; j < fobj.height; ++j) {
            QByteArray line;
            for (int k = 0; k < widthbytes; ++k) {
                word_t bytepos = off + k * fobj.height + j;

                fobj.chars[i].data[j] = fobj.chars[i].data[j] << 8;
                fobj.chars[i].data[j] = fobj.chars[i].data[j] | uint8_t(fnt.at(bytepos));

                if (i == 64) {
                    qDebug() << "setting " << i << j << fobj.chars[i].data;
                }
            }

            fobj.chars[i].data[j] = fobj.chars[i].data[j] >> (8 * widthbytes - w);
        }
    }

    return fobj;
}

Font nefon(const QByteArray &fon, dword_t neoff) // TODO: fon files can return >1 fnt
{
    // Find the resource table
    word_t rtable = Word::fromIndex(fon, neoff + 0x24);
    rtable = rtable + neoff; // this can overflow, does that matter?

    // Read the shift count out of the resource table
    word_t shift = Word::fromIndex(fon, rtable);

    // Now loop over the rest of the resource table.
    word_t p = rtable + 2; // + 2 for shift WORD

    forever {
        word_t rtype = Word::fromIndex(fon, p);
        if (rtype == 0)
            break; // end of resource table

        word_t count = Word::fromIndex(fon, p + 2); // + 2 for rtype WORD
        p = p + 8; // type, count, 4 bytes reserved
        for (word_t i = 0; i < count; ++i) {
            word_t start = Word::fromIndex(fon, p) << shift;
            word_t size = Word::fromIndex(fon, p + 2) << shift;
            if (start < 0 || size < 0 || start + size > fon.length()) {
                qWarning() << "Resource overruns file boundaries";
                return Font();
            }

            if (rtype == 0x8008) {
                // it's a font
                QByteArray fnt(fon.constData() + start, size);
                return dofnt(fnt); // TODO: we should handle >1 FNT in FON
                // TODO: do something with the return value
            }

            p = p + 12; // start, size, flags, name/id, 4 bytes reserved
        }
    }

    return Font();
}


#if 0
                for (int c = 32; c < 256; ++c) {
                    QImage img(fobj.chars[c].width, fobj.height, QImage::Format_ARGB32_Premultiplied);
                    img.fill(Qt::transparent);
                    QPainter p(&img);
                    p.setPen(Qt::black);

                    for (int j = 0; j < fobj.height; ++j) {
                        long v = fobj.chars[c].data[j];
                        long m = 1L << (fobj.chars[c].width - 1);

                        if (c == 64)
                            qDebug() << v << m;

                        QByteArray out;
                        for (int k = 0; k < fobj.chars[c].width; k++) {
                            if (v & m) {
                                out.append("1");
                                p.drawPoint(k, j);
                            }
                            else
                                out.append("0");
                            v = v << 1;
                        }

//                        if (c == 64)
//                            qDebug() << out;
                    }

                    QFile file(QString::fromLatin1("char-%1.png").arg(c));
                    file.open(QIODevice::WriteOnly);
                    img.save(&file, "PNG");
//                    qDebug() << "End";
                }
#endif


Font dofon(const QByteArray &fon)
{
    // Find the NE header
    dword_t neoff = DWord::fromIndex(fon, 0x3c);
    if (fon.at(neoff) == 'N' &&
        fon.at(neoff + 1) == 'E') {
        return nefon(fon, neoff);
    } else if (fon.at(neoff) == 'P' &&
               fon.at(neoff + 1) == 'E' &&
               fon.at(neoff + 2) == '\0' &&
               fon.at(neoff + 3) == '\0') {
        qWarning() << "Unhandled Portable Executable format font";
        return Font();
    } else {
        qWarning() << "NE or PE signature not found";
    }
    return Font();
}

Font readFontFile(const char *fileName)
{
    QFile f(fileName);
    if (!f.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open font file " << f.errorString();
        return Font();
    }

    if (f.size() > 10000 /* arbitrary limit */) {
        qWarning() << "Font is too big";
        return Font();
    }

    QByteArray fontData = f.readAll();
    if (fontData.startsWith("MZ")) {
        // FON file
        return dofon(fontData);
    } else {
        // FNT file
        qWarning() << "Got FNT file, can't handle that";
        return Font();
    }
}

static Font *SystemFont;

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    Font fnt = readFontFile("VGASYS.FON"); // TODO: handle failure
    SystemFont = &fnt;

    QQuickView view(QUrl::fromLocalFile("windows31.qml"));
    view.show();

    return app.exec();
}
