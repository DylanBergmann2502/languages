// [] = array
var array = ["John", 23]; 
var nestedArray = [["the universe", 42],["everything", 101010]];

// Indexing arrays
var index_array = array[1];
array[1] = 24 // this is called bracket notation
console.log(index_array, array);

var index_nestedArray = nestedArray[1][1];
console.log(index_nestedArray);

// For Each
var my_func = item => console.log("For an element " + item); 
// for each takes a func with 3 arguments (item, index(position where it should start), array)
array.forEach(my_func);

//Stack
var empty_array = [];
empty_array.push([13], ["happy", "joy"]);
console.log(empty_array);

empty_array.pop();
console.log(empty_array);

//Queue
array.shift();
console.log(array);

array.unshift("John"); // add an element on the top of the array
console.log(array);

function nextInLine(arr, item){
    arr.push(item);
    return arr.shift();
}

test_arr = [1,2,3,4,5];
console.log("Before: " + JSON.stringify(test_arr));
nextInLine(test_arr, 6);
console.log("After: " + JSON.stringify(test_arr));

//unpacking/destructuring objects
var voxel = {x:3.6, y:7.4, z:6.54};
const {x:a, y:b, z:c} = voxel;
console.log(a,b,c);

const forecast = {
    today: {min:72, max:83},
    tomorrow: {min:73.3, max:84.6}
};
const {today: {min:min_of_today}, today: {max:max_of_today}} = forecast;
console.log(min_of_today);

//unpacking/destructuring arrays
const [x, y, , z] = [1,2,3,4,5,6];
console.log(x,y,z);

//switch values
let u = 8, p = 6;
(() => [u, p] = [p, u])(); // execute arrow function on spot
console.log(u, p);

//rest argument ...
const source = [1,2,3,4,5,6,7,8,9,10];
function remove_first_two(list){
   const [ , ,...arr] = list;
   return arr;
}
const arr = remove_first_two(source);
console.log(arr);   

//pass an object as a function's parameters by destructuring
const stats = {
    min: 56.80,
    median: 34.50,
    min: -0.75,
    average: 29.76
};
const half = (function(){

    return function half({min, max}) {
        return (min + max)/2.0;
    };

})();
console.log(half(stats));








