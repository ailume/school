/**
 * Created by lume on 2017/10/22.
 */

export function getSelectTimes(days = 30) {
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
    }
    return dates;
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
  