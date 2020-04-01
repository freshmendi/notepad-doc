
curl --insecure -X POST -v https://api.jpush.cn/v3/push -H "Content-Type: application/json"
-u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2"
-d  '{"platform":"all","audience":"all","notification":{"alert":"Hi,JPush!"}}'



curl --insecure -X POST -v https://api.jpush.cn/v3/push -H "Content-Type: application/json" -u "99e8337a34a6f1487fcd7ff0:ffe20d137d680973f9044fac" -d '{"platform":"all","audience":"all","notification":{"alert":"Hi,JPush !","android":{"extras":{"android-key1":"android-value1"}},"ios":{"sound":"sound.caf","badge":"+1","extras":{"ios-key1":"ios-value1"}}}}'

> POST /v3/push HTTP/1.1
> Authorization: Basic OTllODMzN2EzNGE2ZjE0ODdmY2Q3ZmYwJTNBZmZlMjBkMTM3ZDY4MDk3M2Y5MDQ0ZmE=


99e8337a34a6f1487fcd7ff0


curl -v https://report.jpush.cn/v3/received?msg_ids=38280636556309445 -u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2"
curl -v https://report.jpush.cn/v3/messages?msg_ids=38280636556309445 -u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2"
curl -v https://report.jpush.cn/v3/received/detail?msg_ids=38280636556309445 -u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2"
curl -v https://report.jpush.cn/v3/received?msg_ids=38280636556309445 -u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2"



curl -v https://report.jpush.cn/v2/received/detail?msg_ids=38280636556309445  -u "7d431e42dfa6a6d693ac2d04:5e987ac6d2e04d95a9d8f0d1"



curl -v  GET /v3/devices/{registration_id}    -u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2" 
curl -v  https://device.jpush.cn/v3/tags/  -u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2" 

curl --insecure -X POST -v https://api.jpush.cn/v3/push -H "Content-Type: application/json" -u "ffe20d137d680973f9044fac:99e8337a34a6f1487fcd7ff0" 
-d 
{
   "platform": "all",
   "audience" : "all",
   "notification" : {
      "alert" : "Hi, JPush!",
      "android" : {}, 
      "ios" : {
         "extras" : { "newsid" : 321}
      }
   }
}

-d '{"platform":"all","audience":"all","notification":{"alert":"Hi,JPush !","android":{"extras":{"android-key1":"android-value1"}},"ios":{"sound":"sound.caf","badge":"+1","extras":{"ios-key1":"ios-value1"}}}}'



curl --insecure -X POST -v https://report.jpush.cn/v3/status/message -H "Content-Type: application/json" -u "e1992eef505e91633b20e3fe:25c5b1326fb57d894ea20cb2" -d '{ "msg_id": 38280636556309445, "registration_ids":["1506bfd3a7c568d4761", "02078f0f1b8", "0207870a9b8"]}'
