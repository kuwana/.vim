// DBê⁄ë±
function connectDb() {
	$connect = mysql_connect (DB_HOST,DB_USER,DB_PASSWORD) or die ("can't connect to DB:".mysql_error());
	mysql_select_db(DB_NAME,$connect) or die ("can't select DB:".mysql_error());
}
