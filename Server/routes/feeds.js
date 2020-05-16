var express = require('express');
var router = express.Router();
var usersRouter = require('./users');

var feedsList = [{"id":125014444,
                "creatBy":{"id":"ahua",
                            "nickName":"阿华",
                            "sex":"男",
                            "adress":"北京市朝阳区",
                            "email":"23989234@qq.com",
                            },
                "creatAt":"2020-04-28 20:00",
                "content":"dsdfsdfasd",
                "location":"北京市·朝阳区",
                "favortes":[{"id":"ahua",
                            "nickName":"阿华",
                            "sex":"男",
                            "adress":"北京市朝阳区",
                            "email":"23989234@qq.com",
                            }],
                "comments":[
                    {"id":359844744,
                    "commentBy":{"id":"ahua",
                                "nickName":"阿华",
                                "sex":"男",
                                "adress":"北京市朝阳区",
                                "email":"23989234@qq.com",
                                },
                    "content":"ddfgdfgdfgdfgdfgdfg",
                    "commentAt":"",
                    }],
                }];

//获取所有的feeds
router.get('/',function (req,res,next) {
    res.send(feedsList);
});
//点赞或取消点赞某条feed{"feed":"","favor":0,userId:""}
router.post('/favor',function(req,res,next) {
    let body = req.body;
    console.log(body);
    for (const feed of feedsList) {
        if (feed["id"] == body["feed"]) {
            console.log(feed["id"])
            if (body["favor"] == 0) {
                //删除点赞
                for (const user of feed.favortes) {
                    if (user["id"] === body["userId"]) {
                        var index = feed.favortes.indexOf(user);
                        feed.favortes.splice(index,1);
                        res.send(feed);
                        break;
                    }
                }
            } else if (body["favor"] == 1) {
                //点赞
                var user = usersRouter.getUser(body["userId"])
                feed.favortes.unshift(user);
                res.send(feed);
            }
            break; 
        }
    } 
});
//评论某条feed{"feed":"","userId":"","content":"",}
router.post('/comment',function(req,res,next) {
    let body = req.body;
    for (const feed of feedsList) {
        if (feed["id"] == body["feed"]) {
            var commentUser = usersRouter.getUser(body["userId"]);
            //date
            var currentDate = new Date();
            //取当前时间戳为Id
            var timestamp = Date.parse(currentDate);
            //当前时间字符串
            var timeStr = getDateStr(currentDate);
            //评论
            var comment = {"id":timestamp,"commentBy":commentUser,"content":body["content"],"commentAt":timeStr};
            feed.comments.unshift(comment);
            res.send(feed);
            break;
        }
    }
});
//发一条feed{"userId":"","content":"","location":""}
router.post('/send',function (req,res,next) {
    let body = req.body;
    //发送人
    var commentUser = usersRouter.getUser(body["userId"]);
    //date
    var currentDate = new Date();
    //取当前时间戳为Id
    var timestamp = Date.parse(currentDate);
    //当前时间字符串
    var timeStr = getDateStr(currentDate);
    //feed
    var feed = {"id":timestamp,
                "creatBy":commentUser,
                "creatAt":timeStr,
                "content":body["content"],
                "location":body["location"],
                "favortes":[],
                "comments":[]
            };
    feedsList.unshift(feed);
    res.send(feed);
});

function getDateStr(date) {
    var y = date.getFullYear();  
    var m = date.getMonth() + 1;  
    m = m < 10 ? ('0' + m) : m;  
    var d = date.getDate();  
    d = d < 10 ? ('0' + d) : d;  
    var h = date.getHours();  
    var minute = date.getMinutes();  
    minute = minute < 10 ? ('0' + minute) : minute; 
    var second= date.getSeconds();  
    second = minute < 10 ? ('0' + second) : second;  
    return y + '-' + m + '-' + d+' '+h+':'+minute+':'+ second; 
}

module.exports = router;