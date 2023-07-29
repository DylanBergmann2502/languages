// const Person = function(name, age) {
//   this.sayHello = () => console.log('hello!');
//   this.name = name;
//   this.age = age;
// };

// const jeff = new Person('jeff', 27);

const personFactory = (name, age) => {
  const sayHello = () => console.log('hello!');
  return { name, age, sayHello };
};

const jeff = personFactory('jeff', 27);
console.log(jeff.name); // 'jeff'
jeff.sayHello(); // calls the function and logs 'hello!'

////////////////////////////////////////////////////////////////
// Little hack
const name2 = "Maynard";
const color = "red";
const number = 34;
const food = "rice";

// logging all of these variables might be a useful thing to do,
// but doing it like this can be somewhat confusing.
console.log(name2, color, number, food); // Maynard red 34 rice

// if you simply turn them into an object with brackets,
// the output is much easier to decipher:
console.log({name2, color, number, food});
 // { name: 'Maynard', color: 'red', number: 34, food: 'rice' }

////////////////////////////////////////////////////////////////
// The concept of closure is the idea that
// functions retain their scope even if
// they are passed around and called outside of that scope.
// In this case, printString has access
// to everything inside of FactoryFunction,
// even if it gets called outside of that function
const FactoryFunction = string => {
  const capitalizeString = () => string.toUpperCase();
  const printString = () => console.log(`----${capitalizeString()}----`);
  return { printString };
};

const taco = FactoryFunction('taco');

// printString(); // ERROR!!
// capitalizeString(); // ERROR!!
// taco.capitalizeString(); // ERROR!!
console.log(taco); // { printString: [Function: printString] }
taco.printString(); // this prints "----TACO----"

////////////////////////////////////////////////////////////
const Player = (name, level) => {
  let health = level * 2;
  const getLevel = () => level;
  const getName  = () => name;
  const die = () => {
    // uh oh
  };
  const damage = x => {
    health -= x;
    if (health <= 0) {
      die();
    }
  };
  const attack = enemy => {
    if (level < enemy.getLevel()) {
      damage(1);
      console.log(`${enemy.getName()} has damaged ${name}`);
    }
    if (level >= enemy.getLevel()) {
      enemy.damage(1);
      console.log(`${name} has damaged ${enemy.getName()}`);
    }
  };
  return {attack, damage, getLevel, getName};
};

const jimmie = Player('jim', 10);
const badGuy = Player('jeff', 5);
jimmie.attack(badGuy);
