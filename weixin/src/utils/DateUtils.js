/**
 * Created by lume on 2017/10/22.
 */

export function getSelectDates(days = 7) {
  let dates = [];
  let currDate = new Date();
  for (let i = 0; i < days; i++) {
    let nextDate = new Date(currDate);
    nextDate.setDate(currDate.getDate() + (i));
    let date = {};
    if (i === 0) {
      date['name'] = '今天';
      date['value'] = '' + currDate.getTime();
      date['date'] = currDate;
    } else if (i === 1) {
      date['name'] = '明天';
      date['value'] = '' + nextDate.getTime();
      date['date'] = nextDate;
    } else {
      date['name'] = formatDate('yyyy-MM-dd', nextDate);
      date['value'] = '' + nextDate.getTime();
      date['date'] = nextDate;
    }
    dates.push(date);
    //计算当天右边数据
    if (i === 0) {
      let oneResults = getDataAtOne(date);
      console.log(oneResults);
      dates.push(...oneResults);
    }
    //计算当天之后右边数据
    for (let j = 0; j < 12; j++) {
      let rightData = {};
      if (i !== 0) {
        let currTime = 8 + j;
        currTime = currTime < 10 ? '0' + currTime + ':00' : currTime + ':00';
        rightData['name'] = currTime;
        rightData['value'] = currTime;
        rightData['parent'] = '' + date.value;
        dates.push(rightData);
      }
    }
  }
  return dates;
}

function getDataAtOne(date) {
  let results = [];
  let currDate = new Date();
  let currHour = currDate.getHours();
  let currMinute = currDate.getMinutes();
  let isOver = (currHour > 19) || (currHour === 19 && currMinute > 0) || (currHour < 7) || (currHour === 7 && currMinute === 0);
  if (isOver) {
    let rightData = {};
    rightData['name'] = '立刻发送';
    rightData['value'] = formatDate('hh:mm');
    rightData['parent'] = '' + date.value;
    results.push(rightData);
  } else {
    for (let i = currHour; i < 20; i++) {
      let rightData = {};
      if (i === currHour) {
        rightData['name'] = '立刻发送';
        rightData['value'] = formatDate('hh:mm');
      } else {
        let currTime = i;
        currTime = currTime < 10 ? '0' + currTime + ':00' : currTime + ':00';
        rightData['name'] = currTime;
        rightData['value'] = currTime;
      }
      rightData['parent'] = '' + date.value;
      results.push(rightData);
    }
  }
  return results;
}

//转换成日期
export function formatDate(format1 = 'yyyy-MM-dd hh:mm:ss', timestamp = new Date()) {
  try {
    timestamp = timestamp.getTime();
    let date = new Date();
    date.setTime(timestamp);
    return date.format(format1);//2014-07-10 10:21:12
  } catch (erro) {
    return '';
  }
  return '';
}

//时间处理
Date.prototype.format = function (format) {
  let date = {
    "M+": this.getMonth() + 1,
    "d+": this.getDate(),
    "h+": this.getHours(),
    "m+": this.getMinutes(),
    "s+": this.getSeconds(),
    "q+": Math.floor((this.getMonth() + 3) / 3),
    "S+": this.getMilliseconds()
  };
  if (/(y+)/i.test(format)) {
    format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
  }
  for (let k in date) {
    if (new RegExp("(" + k + ")").test(format)) {
      format = format.replace(RegExp.$1, RegExp.$1.length === 1
        ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
    }
  }
  return format;
};
