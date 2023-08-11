// Capitalize
function capitalize(str) {
    let uppered_char;
    uppered_char = str[0].toUpperCase();
    str = str.replace(str[0], uppered_char);
    return str;
};

module.exports = capitalize;
