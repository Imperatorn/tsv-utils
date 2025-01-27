#!/usr/bin/env bash

if [ $# -le 1 ]; then
    echo "Insufficient arguments. A program name and output directory are required."
    exit 1
fi

prog=$1
shift
odir=$1
echo "Testing ${prog}, output to ${odir}"

## Three args: program, args, output file
runtest () {
    echo "" >> $3
    echo "====[tsv-filter $2]====" >> $3
    $1 $2 >> $3 2>&1
    return 0
}

basic_tests_1=${odir}/basic_tests_1.txt

echo "Basic tests set 1" > ${basic_tests_1}
echo "-----------------" >> ${basic_tests_1}

# Numeric field tests
echo "" >> ${basic_tests_1}; echo "====Numeric tests===" >> ${basic_tests_1}

runtest ${prog} "--header --eq 2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --eq 2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 2:1. input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 2:1.0 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 2:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 2:-100 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 1:0 --eq 2:100 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 1:0 --ne 2:100 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --le 2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --lt 2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ge 2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --gt 2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ne 2:101 input1.tsv" ${basic_tests_1}

# Numeric field tests: Named field versions
runtest ${prog} "-H --eq F2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --eq F2:1. input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --eq F2:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --eq F2:-100 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --eq F1:0 --eq F2:100 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --eq F1:0 --ne F2:100 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --le F2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --lt F2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --ge F2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --gt F2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --ne F2:101 input1.tsv" ${basic_tests_1}

# Count tests
echo "" >> ${basic_tests_1}; echo "====Count tests===" >> ${basic_tests_1}
runtest ${prog} "--header --eq 2:1 input1.tsv --count" ${basic_tests_1}
runtest ${prog} "--header --le 2:101 input1.tsv -c" ${basic_tests_1}
runtest ${prog} "-H --count --empty F1 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H -c --not-empty F1 input1.tsv " ${basic_tests_1}

runtest ${prog} "--eq 2:1 input1_noheader.tsv --count" ${basic_tests_1}
runtest ${prog} "--le 2:101 input1_noheader.tsv -c" ${basic_tests_1}
runtest ${prog} "--count --empty 1 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "-c --not-empty 1 input1_noheader.tsv " ${basic_tests_1}

# label tests
echo "" >> ${basic_tests_1}; echo "====Label tests===" >> ${basic_tests_1}
runtest ${prog} "--label Pass --header --eq 2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--label PASS --header --le 2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "--label X -H --empty F1 input1.tsv" ${basic_tests_1}

runtest ${prog} "--label Pass --eq 2:1 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--label PASS --le 2:101 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--label X --empty 1 input1_noheader.tsv" ${basic_tests_1}

runtest ${prog} "--label Pass --label-values Y:N --header --eq 2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--label Pass --label-values Yes:No --header --eq 2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--label Pass --label-values Yes: --header --eq 2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--label P --label-values :No --header --eq 2:1 input1.tsv" ${basic_tests_1}

runtest ${prog} "--label Pass --label-values Y:N --eq 2:1 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--label-values Y:N --eq 2:1 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--label PASS -H --or --ge 2:1000 --lt 1:100 input1.tsv input2.tsv" ${basic_tests_1}


# Line buffered tests
echo "" >> ${basic_tests_1}; echo "====Line buffered tests===" >> ${basic_tests_1}
runtest ${prog} "--header --line-buffered --eq 2:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --line-buffered --le 2:101 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --line-buffered --empty F1 input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --line-buffered --not-empty F1 input1.tsv " ${basic_tests_1}
runtest ${prog} "--header --count --line-buffered --le 2:101 input1.tsv" ${basic_tests_1}

runtest ${prog} "--line-buffered --eq 2:1 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--line-buffered --le 2:101 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--line-buffered --empty 1 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--line-buffered --not-empty 1 input1_noheader.tsv " ${basic_tests_1}
runtest ${prog} "--count --line-buffered --le 2:101 input1_noheader.tsv" ${basic_tests_1}

# Empty and blank field tests
echo "" >> ${basic_tests_1}; echo "====Empty and blank field tests===" >> ${basic_tests_1}

runtest ${prog} "--header --empty 3 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 1:100 --empty 3 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 1:100 --empty 4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 1:100 --not-empty 3 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 1:100 --not-empty 4 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --empty 3 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-empty 3 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --blank 3 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-blank 3 input2.tsv" ${basic_tests_1}

runtest ${prog} "--not-blank 1 input_onefield.txt" ${basic_tests_1}
runtest ${prog} "--not-empty 1 input_onefield.txt" ${basic_tests_1}
runtest ${prog} "--blank 1 input_onefield.txt" ${basic_tests_1}
runtest ${prog} "--empty 1 input_onefield.txt" ${basic_tests_1}

# Empty and blank fields: Named field versions
runtest ${prog} "--header --empty F3 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq F1:100 --empty F4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq F1:100 --not-empty F4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-empty F3 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --blank F3 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-blank F3 input2.tsv" ${basic_tests_1}

# Short circuit by order. Ensure not blank or "none" before numeric test.
echo "" >> ${basic_tests_1}; echo "====Short circuit tests===" >> ${basic_tests_1}
runtest ${prog} "--header --not-blank 1 --str-ne 1:none --eq 1:100 input_num_or_empty.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-blank f1 --str-ne 1:none --eq 1:100 input_num_or_empty.tsv" ${basic_tests_1}
runtest ${prog} "--header --or --blank 1 --str-eq 1:none --eq 1:100 input_num_or_empty.tsv" ${basic_tests_1}
runtest ${prog} "--header --invert --not-blank 1 --str-ne 1:none --eq 1:100 input_num_or_empty.tsv" ${basic_tests_1}
runtest ${prog} "--header --invert --or --blank 1 --str-eq 1:none --eq 1:100 input_num_or_empty.tsv" ${basic_tests_1}

# Numeric type recognition and short circuiting.
runtest ${prog} "-H --is-numeric 2 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-finite 2 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-nan 2 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-infinity 2 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-numeric 2 --gt 2:10 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-numeric 2 --le 2:10 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-finite 2 --gt 2:10 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-finite 2 --le 2:10 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-nan f2 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-infinity f2 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-numeric f2 --le f2:10 input_numeric_tests.tsv" ${basic_tests_1}
runtest ${prog} "-H --is-finite f2 --gt f2:10 input_numeric_tests.tsv" ${basic_tests_1}


# String field tests
echo "" >> ${basic_tests_1}; echo "====String tests===" >> ${basic_tests_1}

runtest ${prog} "--header --str-eq 3:a input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq 3:abc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq 4:ABC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq 3:ß input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq 3:àßc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-ne 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-le 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-lt 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-ge 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-gt 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-in-fld 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-in-fld 3:b --str-in-fld 4:b input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --istr-eq 4:ABC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-eq 4:aBc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-eq 4:ÀSSC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-eq 4:àssc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-eq 3:ß input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-eq 3:ẞ input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-eq 3:ÀßC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-ne 4:ABC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-ne 4:ÀSSC input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --istr-in-fld 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-in-fld 3:B input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-in-fld 4:Sc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-in-fld 4:àsSC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-in-fld 3:ẞ input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-not-in-fld 3:B input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-not-in-fld 4:Sc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-not-in-fld 4:àsSC input1.tsv" ${basic_tests_1}

# String field tests: Named fields
runtest ${prog} "--header --str-eq F3:abc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq F4:ABC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq F3:ß input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq F3:àßc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-ne F3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-le F3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-lt F3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-ge F3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-gt F3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-in-fld F3:b input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --istr-eq F4:aBc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-eq F3:ÀßC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-ne F4:ÀSSC input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --istr-in-fld F3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-in-fld F4:àsSC input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-not-in-fld F4:Sc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-not-in-fld F4:àsSC input1.tsv" ${basic_tests_1}

## Can't pass single quotes to runtest
echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --str-in-fld '3: ' input1.tsv]====" >> ${basic_tests_1}
${prog} --header --str-in-fld '3: ' input1.tsv >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --str-in-fld '4:abc def' input1.tsv]====" >> ${basic_tests_1}
${prog} --header --str-in-fld '4:abc def' input1.tsv >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --str-in-fld 'F3: ' input1.tsv]====" >> ${basic_tests_1}
${prog} --header --str-in-fld 'F3: ' input1.tsv >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --str-in-fld 'F4:abc def' input1.tsv]====" >> ${basic_tests_1}
${prog} --header --str-in-fld 'F4:abc def' input1.tsv >> ${basic_tests_1} 2>&1

runtest ${prog} "--header --str-in-fld 3:ß input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-not-in-fld 3:b input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-not-in-fld 3:b --str-not-in-fld 4:b input1.tsv" ${basic_tests_1}

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --str-not-in-fld '3: ' input1.tsv]====" >> ${basic_tests_1}
${prog} --header --str-not-in-fld '3: ' input1.tsv >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --str-not-in-fld '4:abc def' input1.tsv]====" >> ${basic_tests_1}
${prog} --header --str-not-in-fld '4:abc def' input1.tsv >> ${basic_tests_1} 2>&1

runtest ${prog} "--header --str-not-in-fld 3:ß input1.tsv" ${basic_tests_1}

# Regular expression tests
echo "" >> ${basic_tests_1}; echo "====Regular expressions===" >> ${basic_tests_1}

runtest ${prog} "--header --regex 4:Às*C input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --regex 4:^A[b|B]C$ input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --iregex 4:abc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --iregex 3:ß input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --regex 3:ß input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --iregex 4:ß input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --regex 1:^\-[0-9]+ input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-iregex 4:abc input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-regex 4:z|d input1.tsv" ${basic_tests_1}

# Regular expression tests: named fields
runtest ${prog} "-H --regex F4:Às*C input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --regex F4:^A[b|B]C$ input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --regex F1:^\-[0-9]+ input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --not-iregex F4:abc input1.tsv" ${basic_tests_1}
runtest ${prog} "-H --not-regex F4:z|d input1.tsv" ${basic_tests_1}

echo "" >> ${basic_tests_1}; echo "====Character and Byte Length tests===" >> ${basic_tests_1}

runtest ${prog} "--header --char-len-eq 3:0 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-eq 3:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-eq 3:2 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --char-len-ne 3:0 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-ne 3:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-ne 3:2 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --char-len-le 4:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-lt 4:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-gt 4:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-ge 4:2 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --byte-len-eq 3:0 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-eq 3:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-eq 3:2 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --byte-len-ne 3:0 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-ne 3:1 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-ne 3:2 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --byte-len-le 4:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-lt 4:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-gt 4:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-ge 4:2 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --char-len-le 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-lt 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-ge 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-gt 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-eq 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-ne 3:3 input_unicode.tsv" ${basic_tests_1}

runtest ${prog} "--header --byte-len-le 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-lt 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-ge 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-gt 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-eq 3:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-ne 3:3 input_unicode.tsv" ${basic_tests_1}

runtest ${prog} "--header --char-len-lt 1:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-le 2:2 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-ge 4:2 input_unicode.tsv" ${basic_tests_1}

# Character and byte length tests: Named fields
runtest ${prog} "--header --char-len-ge Text*:3 input_unicode.tsv" ${basic_tests_1}
runtest ${prog} "--header --byte-len-ge Text*:3 input_unicode.tsv" ${basic_tests_1}

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --char-len-lt 'Text\ 2:3' input_unicode.tsv] ====" >> ${basic_tests_1}
${prog} --header --char-len-lt 'Text\ 2:3' input_unicode.tsv >> ${basic_tests_1}

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --char-len-lt 'Text\ 2 3' input_unicode.tsv] ====" >> ${basic_tests_1}
${prog} --header --char-len-lt 'Text\ 2 3' input_unicode.tsv >> ${basic_tests_1}

# Field List tests
echo "" >> ${basic_tests_1}; echo "====Field list tests===" >> ${basic_tests_1}
runtest ${prog} "--header --ge 4-6:25 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --gt 4-6:25 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --eq 6-4,8:0 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --ne 4-6,8-9:0 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --or --eq 4-6,8-9:0 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --lt 4,5:0 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --lt 4,5:-1 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --char-len-ge 2-7:2 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --blank 2,3 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --empty 2,3,7 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-eq 4-6:0 input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-in-fld 2-3,7:ab input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-in-fld 2-3:ab input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --str-not-in-fld 2-3:ab input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --or --istr-eq 2-3:abc input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --or --istr-eq 2-3:ABC input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --istr-in-fld 2-3:ab input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --or --regex 2-3,7:^.*b.*d$ input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --not-regex 2-3,7:^.*b.*d$ input4.tsv" ${basic_tests_1}
runtest ${prog} "--header --or --iregex 7,3,2:^.*b.*d$ input4.tsv" ${basic_tests_1}

# Field vs Field tests
echo "" >> ${basic_tests_1}; echo "====Field vs Field===" >> ${basic_tests_1}

runtest ${prog} "--header --ff-eq 1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-ne 1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-le 1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-lt 1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-ge 1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-gt 1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-str-eq 3:4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-str-ne 3:4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-istr-eq 3:4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-istr-ne 3:4 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --ff-absdiff-le 1:2:0.01 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-le 2:1:0.01 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-le 1:2:0.02 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-gt 1:2:0.01 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-gt 1:2:0.02 input2.tsv" ${basic_tests_1}

runtest ${prog} "--header --ff-reldiff-le 1:2:1e-5 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-le 1:2:1e-6 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-le 1:2:1e-7 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-gt 1:2:1e-5 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-gt 1:2:1e-6 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-gt 1:2:1e-7 input2.tsv" ${basic_tests_1}

# Field vs Field tests: named field versions
runtest ${prog} "--header --ff-eq F1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-ne F1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-le F1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-lt F1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-lt F1:F2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-ge F1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-gt F1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-gt F1:F2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-str-eq F3:4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-str-ne F3:4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-istr-eq F3:4 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-istr-ne F3:4 input1.tsv" ${basic_tests_1}

runtest ${prog} "--header --ff-absdiff-le F1:F2:0.01 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-le F2:F1:0.01 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-le F1:F2:0.02 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-gt F1:F2:0.01 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-absdiff-gt F1:F2:0.02 input2.tsv" ${basic_tests_1}

runtest ${prog} "--header --ff-reldiff-le F1:F2:1e-5 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-le F1:F2:1e-6 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-le F1:F2:1e-7 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-gt F1:F2:1e-5 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-gt F1:F2:1e-6 input2.tsv" ${basic_tests_1}
runtest ${prog} "--header --ff-reldiff-gt F1:F2:1e-7 input2.tsv" ${basic_tests_1}

# No Header tests
echo "" >> ${basic_tests_1}; echo "====No header===" >> ${basic_tests_1}
runtest ${prog} "--str-in-fld 2:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--str-eq 3:a input1.tsv" ${basic_tests_1}

runtest ${prog} "--eq 2:1 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--le 2:101 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--lt 2:101 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--empty 3 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--eq 1:100 --empty 3 input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--str-eq 4:ABC input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--str-eq 3:ß input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--regex 4:Às*C input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--regex 4:^A[b|B]C$ input1_noheader.tsv" ${basic_tests_1}
runtest ${prog} "--ff-eq 1:2 input1_noheader.tsv" ${basic_tests_1}

# OR clause tests
echo "" >> ${basic_tests_1}; echo "====OR clause tests===" >> ${basic_tests_1}
runtest ${prog} "--header --or --eq 1:0 --eq 2:101 --str-in-fld 4:def input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --or --le 1:-0.5 --ge 2:101.5 input1.tsv" ${basic_tests_1}

# Invert tests
echo "" >> ${basic_tests_1}; echo "====Invert tests===" >> ${basic_tests_1}
runtest ${prog} "--header --invert --ff-ne 1:2 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --invert --eq 1:0 --eq 2:100 input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --invert --or --eq 1:0 --eq 2:101 --str-in-fld 4:def input1.tsv" ${basic_tests_1}
runtest ${prog} "--header --invert --or --le 1:-0.5 --ge 2:101.5 input1.tsv" ${basic_tests_1}

# Alternate delimiter tests
echo "" >> ${basic_tests_1}; echo "====Alternate delimiter===" >> ${basic_tests_1}
runtest ${prog} "--header --delimiter | --eq 2:1 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --eq 2:-100 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --eq 1:0 --eq 2:100 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --empty 3 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --eq 1:100 --empty 3 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --eq 1:100 --empty 4 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --eq 1:100 --not-empty 4 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --gt 2:101 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --ne 2:101 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --str-eq 3:a input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --str-eq 3:ß input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --str-eq 3:àßc input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --str-ne 3:b input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --str-lt 3:b input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --str-in-fld 3:b input2_pipe-sep.tsv" ${basic_tests_1}

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --delimiter | --str-in-fld '3: ' input2_pipe-sep.tsv]====" >> ${basic_tests_1}
${prog} --header --delimiter '|' --str-in-fld '3: ' input2_pipe-sep.tsv >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --delimiter | --str-in-fld '4:abc def' input2_pipe-sep.tsv]====" >> ${basic_tests_1}
${prog} --header --delimiter '|' --str-in-fld '4:abc def' input2_pipe-sep.tsv >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1}; echo "====[tsv-filter --header --delimiter | --str-not-in-fld '3: ' input2_pipe-sep.tsv]====" >> ${basic_tests_1}
${prog} --header --delimiter '|' --str-not-in-fld '3: ' input2_pipe-sep.tsv >> ${basic_tests_1} 2>&1

runtest ${prog} "--header --delimiter | --ff-eq 1:2 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --ff-ne 1:2 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --ff-le 1:2 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --ff-str-eq 3:4 input2_pipe-sep.tsv" ${basic_tests_1}
runtest ${prog} "--header --delimiter | --ff-str-ne 3:4 input2_pipe-sep.tsv" ${basic_tests_1}

echo "" >> ${basic_tests_1}; echo "====Multi-file & stdin Tests===" >> ${basic_tests_1}
runtest ${prog} "--header --ge 2:23 input_3x2.tsv input_emptyfile.tsv input_3x1.tsv input_3x0.tsv input_3x3.tsv" ${basic_tests_1}

## runtest can't do these. Generate them directly.
echo "" >> ${basic_tests_1}; echo "====[cat input_3x2.tsv | tsv-filter --header --ge 2:23]====" >> ${basic_tests_1}
cat input_3x2.tsv | ${prog} --header --ge 2:23 >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1}; echo "====[cat input_3x2.tsv | tsv-filter --header --ge 2:23 -- input_3x3.tsv - input_3x1.tsv]====" >> ${basic_tests_1}
cat input_3x2.tsv | ${prog} --header --ge 2:23 -- input_3x3.tsv - input_3x1.tsv >> ${basic_tests_1} 2>&1

## These tests are for the output buffering cases.
echo "" >> ${basic_tests_1};
echo "====[seq 100000 | tsv-filter --or --eq 1:1000 --eq 1:1100 --eq 1:5000 --eq 1:10000 --ge 1:70000 | wc -l | tr -d ' ']====" >> ${basic_tests_1}
seq 100000 | ${prog} --or --eq 1:1000 --eq 1:1100 --eq 1:5000 --eq 1:10000 --ge 1:70000 | wc -l | tr -d ' ' >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1};
echo "====[seq 100000 | tsv-filter --le 1:20 | wc -l | tr -d ' ']====" >> ${basic_tests_1}
seq 100000 | ${prog} --le 1:20 | wc -l | tr -d ' ' >> ${basic_tests_1} 2>&1

echo "" >> ${basic_tests_1};
echo "====[seq 100000 | tsv-filter --or --le 1:20 --eq 1:50000 --eq 1:50001 | wc -l | tr -d ' ']====" >> ${basic_tests_1}
seq 100000 | ${prog} --or --le 1:20 --eq 1:50000 --eq 1:50001 | wc -l | tr -d ' ' >> ${basic_tests_1} 2>&1

## Empty file tests
echo "" >> ${basic_tests_1}; echo "====Empty File Tests===" >> ${basic_tests_1}
runtest ${prog} "--ge 3:100 input_emptyfile.tsv" ${basic_tests_1}
runtest ${prog} "-H --ge 3:100 input_emptyfile.tsv" ${basic_tests_1}

## Help and Version printing

echo "" >> ${basic_tests_1}
echo "Help and Version printing 1" >> ${basic_tests_1}
echo "-----------------" >> ${basic_tests_1}
echo "" >> ${basic_tests_1}

echo "====[tsv-filter --help | grep -c Synopsis]====" >> ${basic_tests_1}
${prog} --help 2>&1 | grep -c Synopsis >> ${basic_tests_1} 2>&1

echo "====[tsv-filter --help-verbose | grep -c Synopsis]====" >> ${basic_tests_1}
${prog} --help-verbose 2>&1 | grep -c Synopsis >> ${basic_tests_1} 2>&1

echo "====[tsv-filter --help-options | grep -c Synopsis]====" >> ${basic_tests_1}
${prog} --help-options 2>&1 | grep -c Synopsis >> ${basic_tests_1} 2>&1

echo "====[tsv-filter --help-fields | head -n 1]====" >> ${basic_tests_1}
${prog} --help-fields 2>&1 | head -n 1 >> ${basic_tests_1} 2>&1

echo "====[tsv-filter --version | grep -c 'tsv-filter (eBay/tsv-utils)']====" >> ${basic_tests_1}
${prog} --version 2>&1 | grep -c 'tsv-filter (eBay/tsv-utils)' >> ${basic_tests_1} 2>&1

echo "====[tsv-filter -V | grep -c 'tsv-filter (eBay/tsv-utils)']====" >> ${basic_tests_1}
${prog} -V 2>&1 | grep -c 'tsv-filter (eBay/tsv-utils)' >> ${basic_tests_1} 2>&1


## Error cases

error_tests_1=${odir}/error_tests_1.txt

echo "Error test set 1" > ${error_tests_1}
echo "----------------" >> ${error_tests_1}

runtest ${prog} "--header --le 2:10 nosuchfile.tsv" ${error_tests_1}
runtest ${prog} "--header --gt 0:10 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --lt -1:10 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ne abc:15 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --eq 2:def input1.tsv" ${error_tests_1}
runtest ${prog} "--header --le 1000:10 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --le 1: input1.tsv" ${error_tests_1}
runtest ${prog} "--header --le 1 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --le :10 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --le : input1.tsv" ${error_tests_1}
runtest ${prog} "--header --empty 23g input1.tsv" ${error_tests_1}
runtest ${prog} "--header --empty 0 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-gt 0:abc input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-lt -1:ABC input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-ne abc:a22 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-eq 2.2:def input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-eq 0:def input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-eq :def input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-eq 2: input1.tsv" ${error_tests_1}
runtest ${prog} "--header --str-eq : input1.tsv" ${error_tests_1}
runtest ${prog} "--header --istr-eq 2.2:def input1.tsv" ${error_tests_1}
runtest ${prog} "--header --istr-eq 0:def input1.tsv" ${error_tests_1}
runtest ${prog} "--header --istr-eq :def input1.tsv" ${error_tests_1}
runtest ${prog} "--header --istr-eq 2: input1.tsv" ${error_tests_1}
runtest ${prog} "--header --istr-eq : input1.tsv" ${error_tests_1}
runtest ${prog} "--header --regex z:^A[b|B]C$ input1.tsv" ${error_tests_1}
runtest ${prog} "--header --regex 0:^A[b|B]C$ input1.tsv" ${error_tests_1}
runtest ${prog} "--header --regex :^A[b|B]C$ input1.tsv" ${error_tests_1}
runtest ${prog} "--header --regex 3: input1.tsv" ${error_tests_1}
runtest ${prog} "--header --regex : input1.tsv" ${error_tests_1}
runtest ${prog} "--header --iregex a:^A[b|B]C$ input1.tsv" ${error_tests_1}
runtest ${prog} "--header --iregex 0:^A[b|B]C$ input1.tsv" ${error_tests_1}
runtest ${prog} "--header --iregex :^A[b|B]C$ input1.tsv" ${error_tests_1}
runtest ${prog} "--header --iregex 3: input1.tsv" ${error_tests_1}
runtest ${prog} "--header --iregex : input1.tsv" ${error_tests_1}

# Detailed error messages for invalid regular expressions are subject to change,
# so use a simple error and only capture the first line.

echo "" >> ${error_tests_1}
echo "====[tsv-filter --header --regex 4:abc(d|e input1.tsv 2>&1 | head -n 1]====" >> ${error_tests_1}
${prog} --header --regex 4:'abc(d|e' input1.tsv 2>&1 | head -n 1 >> ${error_tests_1}

echo "" >> ${error_tests_1}
echo "====[tsv-filter --header --iregex 4:abc(d|e input1.tsv 2>&1 | head -n 1]====" >> ${error_tests_1}
${prog} --header --iregex 4:'abc(d|e' input1.tsv 2>&1 | head -n 1 >> ${error_tests_1}

echo "" >> ${error_tests_1}
echo "====[tsv-filter --header --not-regex 4:abc(d|e input1.tsv 2>&1 | head -n 1]====" >> ${error_tests_1}
${prog} --header --not-regex 4:'abc(d|e' input1.tsv 2>&1 | head -n 1 >> ${error_tests_1}

echo "" >> ${error_tests_1}
echo "====[tsv-filter --header --not-iregex 4:abc(d|e input1.tsv 2>&1 | head -n 1]====" >> ${error_tests_1}
${prog} --header --not-iregex 4:'abc(d|e' input1.tsv 2>&1 | head -n 1 >> ${error_tests_1}

runtest ${prog} "--header --ff-gt 0:1 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-gt 1:0 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-lt -1:2 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-lt 1:1 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-ne abc:3 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-eq 2.2:4 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-le 2:3.1 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-le 2: input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-le :10 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-le : input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-str-ne abc:3 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-str-eq 2.2:4 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le 1:2:g input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le 1:2: input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le 1:0:0.5 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le 1:1:0.5 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le 1:g:0.5 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le 1::0.5 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le 0:2:0.5 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le g:2:0.5 input1.tsv" ${error_tests_1}
runtest ${prog} "--header --ff-absdiff-le :2:0.5 input1.tsv" ${error_tests_1}
runtest ${prog} "--eq 2:1 input1.tsv" ${error_tests_1}

# No header versions targeting cases affected by named fields
runtest ${prog} "--ne abc:15 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--le 1: input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--le 1 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--le :10 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--le : input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--empty 23g input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--empty 0 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--str-gt 0:abc input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--str-eq :def input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--regex :^A[b|B]C$ input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--ff-le 2:3.1 input1.tsv" ${error_tests_1}

# Count and Label error tests
runtest ${prog} "--label --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "-H --label --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "-H --label-values Yes:No --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "-H --label any --label-values --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "-H --label any --label-values Yes --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "-H --count --label any --label-values Yes:No --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "-H --count --label any --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--count --label any --ne 1:5 input1_noheader.tsv" ${error_tests_1}
runtest ${prog} "--count --label-values Y:N --ne 1:5 input1_noheader.tsv" ${error_tests_1}

# Standard input tests
echo "" >> ${error_tests_1}; echo "====[cat input_3x2.tsv | tsv-filter --ge 2:23]====" >> ${error_tests_1}
cat input_3x2.tsv | ${prog} --ge 2:23 >> ${error_tests_1} 2>&1

## Windows line endings
runtest ${prog} "--header --eq 2:1 input1_dos.tsv" ${error_tests_1}
runtest ${prog} "--str-eq 4:ABC input1_dos.tsv" ${error_tests_1}
runtest ${prog} "--header --eq 2:1 input1.tsv input1_dos.tsv" ${error_tests_1}
runtest ${prog} "--str-eq 4:ABC input1.tsv input1_dos.tsv" ${error_tests_1}
exit $?
