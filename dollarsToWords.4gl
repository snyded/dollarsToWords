{*
**  dollarsToWords.4gl - convert a numeric dollar amount to words
**  Copyright (C) 2004  David A. Snyder
**
**  This library is free software; you can redistribute it and/or
**  modify it under the terms of the GNU Library General Public
**  License as published by the Free Software Foundation; version
**  2 of the License.
**
**  This library is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
**  Library General Public License for more details.
**
**  You should have received a copy of the GNU Library General Public
**  License along with this library; if not, write to the Free
**  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*}

FUNCTION dollarsToWords(numericDollars)
DEFINE  numericDollars MONEY(8,2)

    DEFINE  stringDollars CHAR(9)
    DEFINE  threeDigitWords CHAR(128)
    DEFINE  finalSentence CHAR(256)
    DEFINE  tempInteger INTEGER

    LET stringDollars = numericDollars USING "&&&&&&.&&"
    INITIALIZE finalSentence TO NULL

    IF stringDollars[1,3] != "000" THEN
        CALL threeDigitParse(stringDollars[1,3]) RETURNING threeDigitWords
        LET finalSentence = threeDigitWords CLIPPED, " THOUSAND"
    END IF

    IF stringDollars[4,6] != "000" THEN
        CALL threeDigitParse(stringDollars[4,6]) RETURNING threeDigitWords
        LET finalSentence = finalSentence CLIPPED, threeDigitWords CLIPPED
    END IF

    IF finalSentence IS NULL THEN
        LET finalSentence = " ZERO"
    END IF
    LET finalSentence = finalSentence CLIPPED, " AND ", stringDollars[8,9], "/100 DOLLARS"

    IF LENGTH(finalSentence) > 70 THEN
        LET tempInteger = numericDollars
        LET finalSentence = tempInteger USING " $<<<,<<&", " AND ", stringDollars[8,9], "/100 DOLLARS"
    END IF

    RETURN finalSentence
END FUNCTION


FUNCTION threeDigitParse(theNumber)
DEFINE  theNumber CHAR(3)

    DEFINE  threeDigitWords CHAR(128)
    DEFINE  tempWords CHAR(10)

    INITIALIZE threeDigitWords TO NULL

    LET tempWords = getHundredsUnits(theNumber, 1)
    IF tempWords != " ZERO" THEN
        LET threeDigitWords = tempWords CLIPPED, " HUNDRED"
    END IF

    LET tempWords = getTens(theNumber)
    IF tempWords != " ZERO" THEN
        LET threeDigitWords = threeDigitWords CLIPPED, tempWords CLIPPED
    END IF

    IF theNumber[2,2] != "1" THEN
        LET tempWords = getHundredsUnits(theNumber, 3)
        IF tempWords != " ZERO" THEN
            LET threeDigitWords = threeDigitWords CLIPPED, tempWords CLIPPED
        END IF
    END IF

    RETURN threeDigitWords
END FUNCTION


FUNCTION getHundredsUnits(theNumber, i)
DEFINE  theNumber CHAR(3)
DEFINE  i SMALLINT

    CASE theNumber[i,i]
        WHEN "0"
            RETURN " ZERO"
        WHEN "1"
            RETURN " ONE"
        WHEN "2"
            RETURN " TWO"
        WHEN "3"
            RETURN " THREE"
        WHEN "4"
            RETURN " FOUR"
        WHEN "5"
            RETURN " FIVE"
        WHEN "6"
            RETURN " SIX"
        WHEN "7"
            RETURN " SEVEN"
        WHEN "8"
            RETURN " EIGHT"
        WHEN "9"
            RETURN " NINE"
    END CASE
END FUNCTION


FUNCTION getTens(theNumber)
DEFINE  theNumber CHAR(3)

    DEFINE  teen_words CHAR(10)

    CASE theNumber[2,2]
        WHEN "0"
            RETURN " ZERO"
        WHEN "1"
            CALL getTeens(theNumber) RETURNING teen_words
            RETURN teen_words
        WHEN "2"
            RETURN " TWENTY"
        WHEN "3"
            RETURN " THIRTY"
        WHEN "4"
            RETURN " FORTY"
        WHEN "5"
            RETURN " FIFTY"
        WHEN "6"
            RETURN " SIXTY"
        WHEN "7"
            RETURN " SEVENTY"
        WHEN "8"
            RETURN " EIGHTY"
        WHEN "9"
            RETURN " NINETY"
    END CASE
END FUNCTION


FUNCTION getTeens(theNumber)
DEFINE  theNumber CHAR(3)

    CASE
        WHEN theNumber[2,3] = "10"
            RETURN " TEN"
        WHEN theNumber[2,3] = "11"
            RETURN " ELEVEN"
        WHEN theNumber[2,3] = "12"
            RETURN " TWELVE"
        WHEN theNumber[2,3] = "13"
            RETURN " THIRTEEN"
        WHEN theNumber[2,3] = "14"
            RETURN " FOURTEEN"
        WHEN theNumber[2,3] = "15"
            RETURN " FIFTEEN"
        WHEN theNumber[2,3] = "16"
            RETURN " SIXTEEN"
        WHEN theNumber[2,3] = "17"
            RETURN " SEVENTEEN"
        WHEN theNumber[2,3] = "18"
            RETURN " EIGHTEEN"
        WHEN theNumber[2,3] = "19"
            RETURN " NINETEEN"
    END CASE
END FUNCTION


