const capitalize = require('./practice');

// Capitalize
test('turn abc to Abc', () => {
  expect(capitalize('abc')).toBe('Abc');
  expect(capitalize('abc')).not.toBe('abc');
});

test('turn Abc to Abc', () => {
  expect(capitalize('Abc')).toBe('Abc');
  expect(capitalize('Abc')).not.toBe('abc');
});


