class OldUser {
  OldUser({this.EmailId,this.password,this.name,this.locationShare,this.groupsIamin,this.location});
   String EmailId ;
   String password;
   String name;
   bool locationShare;
  Map<String,double> location=null;
   List<String> groupsIamin=[];


  OldUser.fromJson(Map value){
    EmailId=value["emailid"];
    name=value["name"];
    locationShare=value["locationShare"];
    groupsIamin=value["groupsIamin"];
  }
   Map toJson(){
     return {"name": name,"locationShare": locationShare,"groupsIamin":groupsIamin,"emailid":EmailId,"location":location};
   }
}
