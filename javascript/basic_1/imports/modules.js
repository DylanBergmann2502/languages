export default class User { //every file can only have one default import
    constructor(name, age) {
        this.name = name;
        this.age = age;
    }
}

export function print_name(user) {
    console.log(`User's name is ${user.name}`)
}

function print_age(user) {
    console.log(`User is ${user.age} years old`)
}

export {print_name}