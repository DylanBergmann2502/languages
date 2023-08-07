`
var p = new Promise(function(resolve, reject) {

	// Do an async task async task and then...

	if(/* good condition */) {
		resolve('Success!');
	}
	else {
		reject('Failure!');
	}
});

p.then(function(result) {
	/* do something with the result */
}).catch(function() {
	/* error :( */
}).finally(function() {
   /* executes regardless or success for failure */
});
`
// Then
new Promise(function(resolve, reject) {
	// A mock async action using setTimeout
	setTimeout(function() { resolve(10); }, 3000);
})
.then(function(result) {
	console.log(result);
});

// From the console:
// 10

// Each then receives the result of the previous then's return value.
new Promise(function(resolve, reject) {
	// A mock async action using setTimeout
	setTimeout(function() { resolve(10); }, 3000);
})
.then(function(num) { console.log('first then: ', num); return num * 2; })
.then(function(num) { console.log('second then: ', num); return num * 2; })
.then(function(num) { console.log('last then: ', num);});

// From the console:
// first then:  10
// second then:  20
// last then:  40

////////////////////////////////////////////////////////////////////////
// Catch
new Promise(function(resolve, reject) {
	// A mock async action using setTimeout
	setTimeout(function() { reject('Done!'); }, 3000);
})
.then(function(e) { console.log('done', e); })
.catch(function(e) { console.log('catch: ', e); });

// From the console:
// 'catch: Done!'

////////////////////////////////////////////////////////////////
// Finally
(new Promise((resolve, reject) => { reject("Nope"); }))
    .then(() => { console.log("success") })
    .catch(() => { console.log("fail") })
    .finally(res => { console.log("finally") });

// >> fail
// >> finally
