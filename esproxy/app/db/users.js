var records = [
    { id: 1, username: 'dave', password: 'dave', displayName: 'Dave', emails: [ { value: 'dave@elastic.co' } ] }
  , { id: 2, username: 'elastic', password: 'changeme', displayName: 'Elastic', emails: [ {value: 'dave@elastic.co'}]}
];

exports.findByUsername = function(username, cb) {
  process.nextTick(function() {
    for (var i = 0, len = records.length; i < len; i++) {
      var record = records[i];
      if (record.username === username) {
        return cb(null, record);
      }
    }
    return cb(null, null);
  });
}