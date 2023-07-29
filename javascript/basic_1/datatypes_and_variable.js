/* undefined, null, boolean, string, symbol, number, and object */
var my_name = "dylan" //used for the whole program
let our_name = "dylan2"; //used for the scope of   
const pi = 3.14 //variable as a constant

var a; //declare a
console.log(a)
a = 7; //after declaring something is a variable, no need to declare it again when initializing it
console.log(a)

var a = 9; //declare and initialize it at the same time

// "let" wont let you declare the same variable twice 
let cat_name = "Quincy";
// let cat_name = "Beau"; 


// // use strict
// function catTalk(){
//     "use strict"; // help to catch coding mistaks like if using an undeclared variable
//     cat_name = "Olivier";
//     quote = cat_name + " says Meow!";
// }
// catTalk();

//scope of let 
function check_scope(){
    "use strict";
    let i = "function scope";
    if (true){
        let i = "block scope"
        console.log("Block scope i is: ", i);
    }
    console.log("Function scope i is: ", i);
    return i;
}
checkScope();

// // const
// function print_many_times() {
//     "use strict";
//     const sentence = "I am cool!";
//     sentence = "I am amazing";
//     console.log(sentence);
// }
// print_many_times();

//const array can't be completely reassigned but can be partially reassigned using dot/bracket notation
const s = [2, 5 , 7];
function edit_in_place(){
    "use strict";
    //s = [2,5,8];
    s[0] = 3;
    console.log(s);
}
edit_in_place();

 //Object.freeze
function freeze_obj(){
    "use strict";
    const math_constants = {pi: 3.14};

    Object.freeze(math_constants);

    try {
        math_constants.pi = 99;
    } catch (ex) {
        console.log(ex);
    }
    return math_constants.pi
}
const PI = freeze_obj();
console.log(PI);

// Anonymous fucntion => Arrow function
var magic = function(){
    return new Date();
};
const magic1 = () => new Date();

var my_concat = function(arr1, arr2){
    return arr1.concat(arr2);
}
const my_concat1 = (arr1, arr2) => arr1.concat(arr2);
console.log(my_concat1([1,2], [3,4,5]));

//Higher order arrow function
const num_list = [ 4, 5.6, -9.8, 3.14, 42, 6, 8.34, -2];
const square_list = arr => {
    const squared_integers = arr.filter(num => Number.isInteger(num) && num > 0).map(x => x * x);
    return squared_integers;
}
const squared_integers = square_list(num_list);
console.log(squared_integers);

//template literals
// backticks enable multiline string 
const person = {
    name: "Dylan Bergmann", 
    age: 29
};

const greeting = `Hello, my name is ${person.name}! 
I am ${person.age} years old.`;

console.log(greeting);