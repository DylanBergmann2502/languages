let user = {
  name: "John",
  surname: "Smith",

//   get fullName() {
//     return `${this.name} ${this.surname}`;
//   },

//   set fullName(value) {
//     [this.name, this.surname] = value.split(" ");
//   },
};

Object.defineProperty(user, 'fullName', {
  get() {
    return `${this.name} ${this.surname}`;
  },

  set(value) {
    [this.name, this.surname] = value.split(" ");
  }
});

console.log(user.fullName); // John Smith

user.fullName = "Alice Cooper";
console.log(user.name); // Alice
console.log(user.surname); // Cooper

////////////////////////////////////////////////////////////////////////////////
let user2 = {
  get name() {
    return this._name;
  },

  set name(value) {
    if (value.length < 4) {
      alert("Name is too short, need at least 4 characters");
      return;
    }
    this._name = value;
  }
};

user2.name = "Pete";
console.log(user2.name); // Pete

user2.name = ""; // Name is too short...
