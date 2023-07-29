function Country(name, traveled) {
  this.name = name ? name : 'United Kingdom';
  this.traveled = Boolean(traveled); // transform to a boolean
}

Country.prototype.travel = function() {
  this.traveled = true;
};

// Constructor invocation
const france = new Country('France', false);
// Constructor invocation
const unitedKingdom = new Country;

france.travel(); // Travel to France
