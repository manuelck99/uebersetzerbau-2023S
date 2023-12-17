%option noyywrap
%option yylineno

%top{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

long long parse_in_base(const char *, int);
}

%x COMMENT

LETTER      [a-zA-Z]
DEC_DIGIT   [0-9]
HEX_DIGIT   [0-9a-fA-F]

%%

"(*" {
    BEGIN(COMMENT);
}
<COMMENT>"*)" {
    BEGIN(INITIAL);
}
<COMMENT>\n
<COMMENT>.

"object"|"int"|"class"|"end"|"return"|"cond"|"continue"|"break"|"not"|"or"|"new"|"null" {
    printf("%s\n", yytext);
}

";"|"("|","|")"|"<-"|"->"|"-"|"+"|"*"|">"|"#" {
    printf("%s\n", yytext);
}

{LETTER}({LETTER}|{DEC_DIGIT}|"_")* {
    printf("id %s\n", yytext);
}

{DEC_DIGIT}({DEC_DIGIT}|"_")* {
    printf("num %lld\n", parse_in_base(yytext, 10));
}

"0x"({HEX_DIGIT}|"_")*{HEX_DIGIT}({HEX_DIGIT}|"_")* {
    printf("num %lld\n", parse_in_base(yytext, 16));
}

(" "|\t|\n)+

. {
    printf("Lexical error on line %d: %s\n", yylineno, yytext);
    exit(1);
}

%%

int main(void) {
    yylex();
    exit(0);
}

long long parse_in_base(const char *str, int base) {
    size_t str_len = strlen(str);
    char *str_cpy = malloc(str_len + 1);

    size_t i_read = 0;
    size_t i_write = 0;
    for (; str[i_read] != '\0' && i_read < str_len; i_read++) {
        if (str[i_read] == '_') {
            continue;
        }
        str_cpy[i_write] = str[i_read];
        i_write++;
    }
    str_cpy[i_write] = '\0';
    long long num = strtoll(str_cpy, NULL, base);
    free(str_cpy);

    return num;
}
