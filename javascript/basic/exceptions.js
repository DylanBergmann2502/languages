// Try, catch, finally
try {
    console.log('Start of try runs');
    unicycle;
    console.log('End of try runs -- never reacher');
}
catch(err){
    console.log('Error has occurred: ' + err);
}
finally {
    console.log('This is always run');
}

// Throwing errors
let json = {'age':30};
try {
    let user = JSON.parse(json);
    if (!user.name){
        throw new SystemError("Incomplete data: no name");
    }
    console.log(user.name);
}
catch (e){
    console.log("JSON error: " + e);
}

