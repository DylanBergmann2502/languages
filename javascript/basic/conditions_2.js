// For ... in = objects
const post = {
    "id":1,
    'title': 'post title',
    'body': 'post body'
};

for (let key in post){
    console.log(post[key]);
}

//For ... of = arrays
const numbers = [1,3,4,5,8,9];
for (let number of numbers){
    console.log(number);
}