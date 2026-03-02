# Network diagram
id | subnet           | dhcp        | comments
-- | ---------------- | ----------- | -------------
1  | 192.168.??.??/28 | printserver | wan
41 | 172.17.0.0/24    | docker      | containers
42 | 10.0.42.0/24     | router      | core services
67 | 10.0.67.0/24     | router      | vpn services
