#ifndef FONT_H
#define FONT_H

typedef uint16_t word_t;
typedef uint32_t dword_t;

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

    static Font fromFile(const char *fileName);
};

#endif
