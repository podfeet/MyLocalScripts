#!/bin/bash

# A small script designed to take an input file of a PDF, run it through the library ocrmypdf, and send the resulting OCR'd file to the same name with the extension "-OCR.pdf" on the end

# assign a variable name to the input file including extension and path
# inputName=$1
inputName=$(readlink -f $1)

# put the path into a variable
dirName=$(dirname $inputName)
# echo $dirName

# Strip the path and file extension and assign to a variable
inputBaseName=$(basename $inputName .pdf)

# Create a variable to add the text "-OCR" and the file extension .pdf
add="-OCR.pdf"

# Create a variable for the output file name that concatenates the base name of the input and adds -0CR and the file extension .pdf
outputName=${dirName}/${inputBaseName}${add}
echo "outputName is $outputName"

# Run ocrmypdf on the original input file name, set the output to pdf and save to the new inputName with -OG and .pdf
# As I'm going to use this shell script inside a Keyboard Maestro macro, I have to specify the full path (KBM doesn't know the path)

/opt/homebrew/bin/ocrmypdf --output-type pdf $inputName $outputName