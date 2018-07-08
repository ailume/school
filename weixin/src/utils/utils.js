export function choose(scopeData,items){
    let arr = [];
    scopeData.forEach((scopes, index) => {
        console.log(scopes)
        if (scopes.selected) {
            arr.push(scopes);
          }
        scopes.CLASS_LIST.forEach((scope) => {
          if (scope.selected) {
            arr.push(scope);
          }
        });
      });

      console.log("ok")
      console.log(arr)

    for( let i=0; i < arr.length; i++ ){
          let li = arr[i].COURSE_ID
          if( li !== items.COURSE_ID ){
            arr[i].selected = false;
          }
      }  

}