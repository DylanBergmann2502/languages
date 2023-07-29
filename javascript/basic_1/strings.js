//Escape characters
//Using backslash \
var myStr = "I am a \"double quotes\" string inside \"double quotes\""
console.log(myStr);

//Using ''
var myStr = ' "I am a "double quotes" string inside "double quotes" '
console.log(myStr);

//Using ticks
var myStr = `'"I am a "double quotes" string inside "double quotes"' `
console.log(myStr);

/*
CODE | OUTPUT
\'      '
\"      "
\\      \
\n      new line
\r      carriage return
\t      tab
\b      backspace
\f      form feed
*/

myVar = "FirstLine\n\t\\SecondLine\nThirdLine";
console.log(myVar);

//Concatenation

var ourString = "I come first. " + "You follow.";
console.log(ourString);

var ourString = "I come first. ";
ourString += "Then, you follow.";
console.log(ourString);

var he = "He goes second. ";
var we = "I go first. " + he + "You go last.";
console.log(we);

var adj = "awesome";
var i = "Bergmann is ";
i += adj;
console.log(i);

//Length, Indexing

var lastName = "Bergmann";

var lastNameLen = lastName.length;
console.log(lastNameLen);

var firstLetter = lastName[0];
console.log(firstLetter);

var lastLetter = lastName[lastNameLen - 1]
console.log(lastLetter);

//Matlib
function matLib(noun, adj, verb, adv){
    var result = "";
    result += "The " + adj + " " + noun + " " + verb + " " + adv;
    return result;
}
console.log(matLib("dog", "big", "ran", "quickly"));



