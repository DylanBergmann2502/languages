//Object
var dog = { //property:value
    "name": "black", "her legs": 4, "tail": 1, "friends": ["me", "my dad"]
};

//Object property
console.log(dog.name); // this is dot notation
console.log(dog["her legs"]); // this is bracket notation => used when property has spaces

dog.name = "white";
console.log(dog.name);

// add new property
dog.bark = "grrrr!!"
dog['bark again'] = "gooo!!"
console.log(dog);

// delete a property
delete dog['bark again'];
console.log(dog);

// check if property exists
console.log(dog.hasOwnProperty("name"));
console.log(dog.hasOwnProperty("ears"));

//Nested object
var storage = {
    "car": {
        "inside":{
            "glove box":"maps",
            "passenger seat": "crumbs"
        },
        "outside":{
            "trunk": "jack"
        }
    },
};
console.log(storage.car.inside["glove box"]);

var plants = [
    {type: "flower", list: ["rose", "tulip", "dandelion"]},
    {type: "trees", list: ["fir", "pine", "birch"]}
];
console.log(plants[1].list[1]);

//Create an object
const create_person = (name, age, gender) => ({name, age, gender});
console.log(create_person("Dylan Bergmann", 29, "male"));

// Object Method
const cat = {
    name: "Daisy",
    speaks() { //speaks: function(){
        console.log(`My name is ${this.name}`);
    }
}
cat.speaks();

// Create a class
class Fruit {
    constructor(name){
        this.name = name;
    }
}

var watermelon = new Fruit("Watermelon");
console.log(watermelon.name);

//getter and setter
class Thermostat {
    constructor(temp){
        this._temp = 5/9 * (temp - 32); 
    }
    get temperature(){
        return this._temp;
    }
    set temperature(updated_temp){
        this._temp = updated_temp;
    }
}

const my_thermos = new Thermostat(100);
console.log(my_thermos.temperature);
my_thermos.temperature = 26;
console.log(my_thermos.temperature);
