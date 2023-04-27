import User, {print_name as pu, print_age as pa} from '/modules.js' 
// import U from '/modules.js' //default import can be outside {}, non default =  inside {}

const user = new User('bob', 11)
console.log(user)
pu(user)
pa(user)