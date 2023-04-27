// if
// ==, ===, !=, !== 
function testEqual(val) {
    if (val == 12) {
        return "Equal";
    }
    return "Not Equals";
}
console.log(testEqual(12));
console.log(testEqual('12'));
console.log("-------------");

function testStrict(val) {
    if (val === 12) {
        return "Equal";
    }
    return "Not Equals";
}
console.log(testStrict(12));
console.log(testStrict('12'));
console.log("-------------");

function testNotEqual(val) {
    if (val != 12) {
        return "Not Equal";
    }
    return "Equals";
}
console.log(testNotEqual(12));
console.log(testNotEqual('12'));
console.log("-------------");

function testStrictNotEqual(val) {
    if (val !== 12) {
        return "Not Equals";
    }
    return "Equals";
}
console.log(testStrictNotEqual(12));
console.log(testStrictNotEqual('12'));
console.log("-------------");

// >, >=, <, <=
function greaterThan100(val) {
    if (val > 100) {
        return "Over 100";
    }
    return "Under 100";
}
console.log(greaterThan100(200));

function between25And50(val) {
    if (val <= 50 && val >= 25) {
        return true;
    }
}
console.log(between25And50(30));

function lessThan25OrGreaterThan50(val) {
    if (val > 50 || val < 20) {
        return true;
    }
}
console.log(lessThan25OrGreaterThan50(75));

// if ... else
function testElse(val){
    var result = "";

    if (val > 5){
        result = "bigger than 5";
    } else {
        result = "5 or smaller";
    }
    return result;
}

// else if
function testElseIf(val){
    if (val > 10){
        return "greater than 10";
    } else if (val < 5) {
        return "smaller than 5";
    }
    return "between 5 and 10";
}
console.log(testElseIf(7));

//order of ifs
function testOrder(val) {
    if (val < 10) { // when top condition is met, all below will be dismissed no matter what
        return "less than 10";
    } else if (val < 5) {
        return "less than 5";
    }
}
console.log(testOrder(3));

//ternary operator
function checkEqual(a, b){
    return a === b ? true : false;
    // if (a===b) { return true; } else { return false; }
}

function checkSign(num){
    return num > 0 ? "positive" : num < 0 ? "negative" : "It's zero!!"
}

//switch
function getDateOfWeek(val){
    switch(val){
        case 0: 
            return "Monday";
            break;
        case 1: 
            return "Tuesday";
            break;
        case 2:
            return "Wednesday";
            break;
        case 3:
            return "Thursday";
            break;
        case 4:
            return "Friday";
            break;
        case 5:
            return "Saturday";
            break;  
        case 6:
            return "Sunday";
            break;  
    }
}

console.log(getDateOfWeek(0));

function sequentialSize(val){
    var answer = "";
    switch(val){
        case 1:
        case 2:
        case 3:
            answer = "low";
            break;
        case 4:
        case 5:
        case 6:
            answer = "mid";
            break;
        case 7:
        case 8:
        case 9:
            answer = "high";
            break;            
    }
    return answer;
}
console.log(sequentialSize(4));

function isLess(a, b){
    return a < b; // shortcut for true/false
}
console.log(isLess(15,10));

//while loop
var array = [];
var n = 0;
while (n<5) {
    array.push(n);
    n++;
}
console.log(array);

//for loop
var anotherArray = [];
for (var i = 0; i < 10; i+=2){ // variable initialization; condition; end of each iteration
    anotherArray.push(i);
}
console.log(anotherArray);

//iterate through an array
var iteratedArray = [1,2,3,4,5,6];
var total = 0;
for (var n = 0; n < iteratedArray.length; n++){
    total += iteratedArray[n];
}
console.log(total);

// do while loop = run the inside code at least once before checking the condition
var num1 = 10;
var testArray1 = [];
var num2 = 10;
var testArray2 = [];
while (num1 < 5){
    testArray1.push(num1);
    num1++;
}
console.log(num1, testArray1);

do {
    testArray2.push(num2);
    num2++;
} while (num2 < 5);
console.log(num2, testArray2);


