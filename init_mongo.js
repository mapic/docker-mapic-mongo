
// get env
var password = MAPIC_MONGO_AUTH;
var user = MAPIC_MONGO_USER || 'mapic_mongo_user';
var database = MAPIC_MONGO_DB || 'mapic';

// prime db for auth
var admin = connect('localhost:27017/admin');
admin.system.users.remove({})

// add user
var db = connect('localhost:27017/' + database);
db.createUser({user : user, pwd: password, roles : [{role : 'root', db: 'admin'}, {role : 'dbOwner', db: database}]})
