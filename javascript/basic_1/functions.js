function substraction(a, b){
    console.log(a-b);
}
substraction(10, 5);

function addition(a,b){
    return a + b;
}
console.log(addition(5, 6));

var a = 4;
function multiplyBy2(num){
    num *= 2;
}
multiplyBy2(a);
console.log(a);


//Global scope
var global = 10;
function func1(){
    another_global = 5; // if you don't use anything when assign a variable, it automatically takes it as a VAR type
}
function func2(){
    var output = "";
    if (typeof global != "undefined"){
        output += "Global: " + global;
    }
    if (typeof another_global != "undefined"){
        output += ". Another global:  " + another_global;
    }
    console.log(output);
}
func1();
func2();

//Local scope
function localScope(){
    local = 15;
    console.log(local);
}
localScope();
// console.log(local); // ReferenceError: local is not define

//Global and Local Scope
outerWear = "T-shirt";
function outfit(){
    var outerWear = "sweater"; // local variable takes precedence over global inside the function
    return outerWear;
}

console.log(outfit());
console.log(outerWear);

//default parameters
const increment = (number, value = 1) => (number*value);
console.log(increment(5, 4));
console.log(increment(5));



