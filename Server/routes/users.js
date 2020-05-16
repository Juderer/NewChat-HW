var express = require('express');
var router = express.Router();
var usersList = [[{"id":"ahua",
                  "nickName":"阿华",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"bihui",
                  "nickName":"毕辉",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"caiwen",
                  "nickName":"蔡文",
                  "sex":"女",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"daiming",
                  "nickName":"戴铭",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"geqiang",
                  "nickName":"葛强",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"huangrong",
                  "nickName":"黄蓉",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"jinxin",
                  "nickName":"金鑫",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"kangjian",
                  "nickName":"康健",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"luoshan",
                  "nickName":"罗山",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"nuobei",
                  "nickName":"诺贝",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"wangshan",
                  "nickName":"王珊",
                  "sex":"女",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                  [{"id":"zhangyi",
                  "nickName":"张毅",
                  "sex":"男",
                  "adress":"北京市朝阳区",
                  "email":"23989234@qq.com",
                  }],
                ];
//拉取所有好友信息
router.get('/', function(req, res, next) {
  res.send(usersList);
});
//拉取某位好友信息
router.get('/:id',function (req, res, next) {
  let userId = req.params["id"];
  let user = getUser(userId);
  res.send(user);
});

function getUser(Id) {
  let u;
  for (const users of usersList) {
    for (const user of users) {
      if (user["id"] === Id) {
        u = user;
        break;
      }
    }
  }
  return u;
}
//修改用户信息
router.post('/',function (req,res,next) {
  let modifierUser = req.body;
  for (const users of usersList) {
    for (const user of users) {
      if (modifierUser["id"] === user["id"]) {
        user["id"] = modifierUser["id"];
        user["nickName"] = modifierUser["nickName"];
        user["sex"] = modifierUser["sex"];
        user["adress"] = modifierUser["adress"];
        user["email"] = modifierUser["email"];
        res.send(getUser(user["id"]));
        break;
      }
    }
  }
});
module.exports = {"router":router,"getUser":getUser};
