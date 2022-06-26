pragma solidity >=0.7.0 <0.9.0;
contract hackathon{
    struct User {
        string name;
        string age;
        string gender;
        string country;
        string city;
    }
    struct TransactionRecord{
        address payable to;
        string sender;
        string note;
        uint ammount;
        bool sent;
        bytes data;
    }
    struct Doctor{
        string _name;
        string _address;
        string _gender;
        string _experiance;
        string _hospitalAddress;
        string specialist;
    }
    struct Hospital{
        string _name;
        string _hospitalLocation;
        string _wallet;
    }
    struct Labortary{
        string _name;
        string _labortaryLocation;
        string _wallet;
    }
    struct MedicalReport{
        address to;
        string from;
        string date;
        string url;
    }
    function toString(bytes memory data) public pure returns(string memory) {
    bytes memory alphabet = "0123456789abcdef";

    bytes memory str = new bytes(2 + data.length * 2);
    str[0] = "0";
    str[1] = "x";
    for (uint i = 0; i < data.length; i++) {
        str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
        str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
    }
    return string(str);
}
    mapping(string=>mapping(string=>bool)) isAvailible;
    mapping(string => mapping(string=>address[])) medicines;
    mapping(string=>mapping(address=>uint)) medicineIndex; 
    mapping(string=>bool) isRegisted; // string is address
    mapping(string=>User) user; // string is address
    mapping(string=>TransactionRecord[]) transactions;
    mapping(string=>Hospital) hospital; // the hospital is registered on the address
    mapping(string =>Hospital[]) hospitalsInTheCity;
    mapping(string=>Doctor) doctor; // the doctor is registered on the address
    mapping(string=>Doctor[]) specialist; // the specialist doctors 
    mapping(string=>mapping(string=>Doctor[])) citySpecialists; // the specialist doctors of the city
    mapping(string=>string[]) citySpecialistsReferences; // string[] stores the reference of doctor
    mapping(address=>MedicalReport[]) userMedicalReports; // getting medical reports for users
    mapping(string=>mapping(string=>MedicalReport[])) labMedicalReports; // getting medical reports for users
    mapping(string=> mapping(string=>MedicalReport)) report; // reports issued by the lab;
    mapping(string=>Labortary) lab; // get lab by id
    mapping(string=>Labortary[]) labinTheCity; // labortaies in the city
    mapping(string=>bool) labCheck; 

    function sendFunds(address payable to,string memory note) public payable{
       
        string memory sender = toString(abi.encodePacked(msg.sender));
        (bool sent, bytes memory data) = to.call{value: msg.value}("");
        transactions[sender].push(TransactionRecord(to,sender,note,msg.value,sent,data));
    }
    function getTransactionHistory() public view returns(TransactionRecord[] memory){
        return transactions[toString(abi.encodePacked(msg.sender))];
    }

   // Hospitals
   function registerHospital(string memory name,string memory location,string memory city)public{
       hospital[toString(abi.encodePacked(msg.sender))] = Hospital(name,location,toString(abi.encodePacked(msg.sender))) ;
       hospitalsInTheCity[city].push(Hospital(name,location,toString(abi.encodePacked(msg.sender))));
   }
   function getHospitalsFromTheCity(string memory city) public view returns (Hospital[] memory){
       return hospitalsInTheCity[city];
   } 
   function getHospital(string memory _address)public view returns(Hospital memory){
       return hospital[_address];
   }
   // Labortary
   function registerLab(string memory name,string memory location, string memory city) public{
       string memory owner = toString(abi.encodePacked(msg.sender));
       lab[owner] = Labortary(name,location,owner);
       labinTheCity[city].push(Labortary(name,location,owner));
       labCheck[owner]=true;
   }
   function getLab(string memory _address) public view returns (Labortary memory ){
       return lab[_address];
   } 
   function getLabFromCity(string memory _city) public view returns (Labortary[] memory){
       return labinTheCity[_city];
   }
   // doctors
    
   function registerDoctor(string memory _name, string memory city,string memory gender,string memory experience, string memory _hospitalAddress,string memory _specialist) public{
        doctor[toString(abi.encodePacked(msg.sender))] = Doctor(_name,toString(abi.encodePacked(msg.sender)),gender,experience,_hospitalAddress,_specialist);
        specialist[_specialist].push(Doctor(_name,toString(abi.encodePacked(msg.sender)),gender,experience,_hospitalAddress,_specialist));
        citySpecialists[city][_specialist].push(Doctor(_name,toString(abi.encodePacked(msg.sender)),gender,experience,_hospitalAddress,_specialist));
        citySpecialistsReferences[city].push(toString(abi.encodePacked(msg.sender)));
   }
   function getDoctor(string memory _address)public view returns(Doctor memory){
       return doctor[_address];
   }
   function getDoctorSpecialistInTheCity(string memory city, string memory specialization)public view returns(Doctor[] memory){
       return citySpecialists[city][specialization];
   }
   function getSpecialist(string memory specialization)public view returns (Doctor[] memory){
       return specialist[specialization];
   }

   // Users
    function isPersonRegistered() public view returns (bool){
        return isRegisted[toString(abi.encodePacked(msg.sender))];
    }
    function registerPatient(string memory _name, string memory _age, string memory _gender, string memory _country,string memory city) public {
       require(isRegisted[toString(abi.encodePacked(msg.sender))] != true,"Already exist");
        string memory Address = toString(abi.encodePacked(msg.sender)); 
        user[Address] = User(_name,_age,_gender,_country,city);
        isRegisted[Address] = true;
    }



    function getUserData() public view returns (User memory){
        return user[toString(abi.encodePacked(msg.sender))];
    }
    function getCityName() public view returns (string memory){
        return  user[toString(abi.encodePacked(msg.sender))].city;
    }
    // medical Report 
    
    function issueReport(address to, string memory date ,string memory url,string memory id) public {
        require( labCheck[toString(abi.encodePacked(msg.sender))]==true,"You need to be lab owner");
        string memory sender = toString(abi.encodePacked(msg.sender));
        userMedicalReports[to].push(MedicalReport(to,sender,date,url));
        labMedicalReports[sender][sender].push(MedicalReport(to,sender,date,url));
        report[sender][id] = MedicalReport(to,toString(abi.encodePacked(msg.sender)),date,url);
    }
    function getMyMedicalReports() public view returns (MedicalReport[] memory){
        return userMedicalReports[msg.sender];
    }
    function getIssuedReports() public view returns (MedicalReport[] memory){
        return labMedicalReports[toString(abi.encodePacked(msg.sender))][toString(abi.encodePacked(msg.sender))];
    }
    function getReportById(string memory id) public view returns (MedicalReport memory){
        return report[toString(abi.encodePacked(msg.sender))][id];
    }

    function addMedicine(string memory name,string memory city) public {
     
        require(isAvailible[toString(abi.encodePacked(msg.sender))][name] != true,"Already exist");
        medicines[city][name].push(msg.sender);
        isAvailible[toString(abi.encodePacked(msg.sender))][name] = true;
    }
    function removeMedicines(string memory name) public {
        require(isAvailible[toString(abi.encodePacked(msg.sender))][name] == true,"Not exist");
        isAvailible[toString(abi.encodePacked(msg.sender))][name] = false;
    }
    function isMedicineAvailible(string memory name,string memory owner) public view returns (bool){
        return isAvailible[owner][name];
    }
    function getMedicines(string memory name,string memory city) public view returns (address[] memory){
        return medicines[city][name];
    }
}