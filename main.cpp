//
// Copyright (C) 2014, Robin Burchell <robin+git@viroteck.net>
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

#include <QGuiApplication>
#include <QDebug>
#include <QQuickView>
#include <QPainter>
#include <QDir>

#include "font.h"

QString adjustPath(const QString &path)
{
  #ifdef Q_OS_MAC
    if (!QDir::isAbsolutePath(path))
        return QString("%1/../Resources/%2").arg(QCoreApplication::applicationDirPath(), path);
  #endif
    return path;
}

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);
#if 0
    Font fobj = Font::fromFile("VGASYS.FON"); // TODO: handle failure

    // For ease of use, dump the PNGs.
    // TODO: we should get more fancy and do these using an image provider.
    for (int c = 32; c < 256; ++c) { // TODO: unfortunate hardcodes
        QImage img(fobj.chars[c].width, fobj.height, QImage::Format_ARGB32_Premultiplied);
        img.fill(Qt::transparent);
        QPainter p(&img);
        p.setPen(Qt::white);

        for (int j = 0; j < fobj.height; ++j) {
            long v = fobj.chars[c].data[j];
            long m = 1L << (fobj.chars[c].width - 1);

            for (int k = 0; k < fobj.chars[c].width; k++) {
                if (v & m) {
                    p.drawPoint(k, j);
                }
                v = v << 1;
            }
        }

        QFile file(QString::fromLatin1("VGASYS/white/char-%1.png").arg(char(c)));
        file.open(QIODevice::WriteOnly);
        img.save(&file, "PNG");
    }
#endif

    QQuickView view(adjustPath("windows31.qml"));
    view.show();

    return app.exec();
}
