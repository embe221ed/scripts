/// Helper functions to convert between float and integer primitives
var buf = new ArrayBuffer(8); // 8 byte array buffer
var f64_buf = new Float64Array(buf);
var u64_buf = new Uint32Array(buf);

/**************************************************************
 *             _            
 *    ___ ___ | | ___  _ __ 
 *   / __/ _ \| |/ _ \| '__|
 *  | (_| (_) | | (_) | |   
 *   \___\___/|_|\___/|_|   
 *                          
 **************************************************************/
const RED       = "\033[0;31m";
const BLUE      = "\033[0;34m";
const GREEN     = "\033[0;32m";
const RESET     = "\033[0;0m";

function info() {
    let msg = Array.prototype.join.call(arguments, " ");
    console.log(BLUE + "[*]", msg, RESET);
}

function success() {
    let msg = Array.prototype.join.call(arguments, " ");
    console.log(GREEN + "[+]", msg, RESET);
}

function error() {
    let msg = Array.prototype.join.call(arguments, " ");
    console.log(RED + "[!]", msg, RESET);
}

/**************************************************************
 *   _          _                     
 *  | |__   ___| |_ __   ___ _ __ ___ 
 *  | '_ \ / _ \ | '_ \ / _ \ '__/ __|
 *  | | | |  __/ | |_) |  __/ |  \__ \
 *  |_| |_|\___|_| .__/ \___|_|  |___/
 *               |_|                  
 * 
 **************************************************************/
function ftoi(val) { // typeof(val) = float
    f64_buf[0] = val;
    return BigInt(u64_buf[0]) + (BigInt(u64_buf[1]) << 32n); // Watch for little endianness
    // w/o BigInt 
    // return u64_buf[0] + (u64_buf[1] * 0x100000000); 
}

function itof(val) { // typeof(val) = BigInt
    u64_buf[0] = Number(val & 0xffffffffn);
    u64_buf[1] = Number(val >> 32n);
    // w/o BigInt
    //u64_buf[0] = parseInt(val % 0x100000000);
    //u64_buf[1] = parseInt((val - u64_buf[0]) / 0x100000000);
    return f64_buf[0];
}

function hex(val) {
    return "0x" + Number(val).toString(16);
}

/**************************************************************
 *                   _       _ _   
 *    _____  ___ __ | | ___ (_) |_ 
 *   / _ \ \/ / '_ \| |/ _ \| | __|
 *  |  __/>  <| |_) | | (_) | | |_ 
 *   \___/_/\_\ .__/|_|\___/|_|\__|
 *            |_|                  
 * 
 **************************************************************/
function addrOf(o) {
    // return address of o: Object
}

function fakeObj(addr) {
    // return object with address addr: BigInt
}

function readData(addr) {
    // return data under address addr: BigInt
}

function writeData(addr, val) {
    // write data to address
}
