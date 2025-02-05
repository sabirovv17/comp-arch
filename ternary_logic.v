module ternary_min(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;
  
  wire bbth;
  wire aath;
  wire cct;
  wire tta;
  wire bat;
  wire battta;
  wire bimbim;
  wire pupu;
  wire pipapu;
  wire pupupipapu;

  and_gate and_gate1(a[1], b[1], out[1]);

  not_gate not_gate1(a[0], nota0);
  not_gate not_gate2(b[0], notb0);
  not_gate not_gate3(a[1], nota1);
  not_gate not_gate4(b[1], notb1);

  and_gate and_gate52(a[1], nota0, bbth);
  and_gate and_gate2(notb1, b[0], aath);
  and_gate and_gate3(bbth, aath, cct);

  and_gate and_gate4(nota1, a[0], tta);
  and_gate and_gate5(notb1, b[0], bat);
  and_gate and_gate6(tta, bat, battta);

  and_gate and_gate7(nota1, a[0], bubu);
  and_gate and_gate8(b[1], notb0, tutu);
  and_gate and_gate9(bubu, tutu, bimbim);

  or_gate or_gate1(battta, bimbim, pupupipapu);
  or_gate or_gate22(pupupipapu, cct, out[0]);

  // TODO: implementation
endmodule

module ternary_max(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;

  wire pp;
  wire rr;
  wire mm;
  wire nono;
  wire ddd;
  wire nnnn;
  wire sum;
  wire notsum;
  wire sss;
  wire ababa;

  or_gate or_gate1(a[1], b[1], out[1]);

  not_gate not_gate1(a[0], nota0);
  not_gate not_gate2(b[0], notb0);
  not_gate not_gate3(a[1], nota1);
  not_gate not_gate4(b[1], notb1);

  and_gate and_gate1(nota1, nota0, pp);
  and_gate and_gate2(notb1, b[0], rr);
  and_gate and_gate3(pp, rr, mm);

  and_gate and_gate4(nota1, a[0], ddd);
  and_gate and_gate5(notb1, notb0, nono);
  and_gate and_gate6(ddd, nono, nnnn);

  and_gate and_gate7(nota1, a[0], sum);
  and_gate and_gate8(notb1, b[0], notsum);
  and_gate and_gate9(sum, notsum, sss);

  or_gate or_gate2(nnnn, sss, ababa);
  or_gate or_gate3(mm, ababa, out[0]);

  // TODO: implementation
endmodule

module ternary_any(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;

  wire [1:0] nota;
  wire [1:0] notb;

  not_gate not_gate1(a[0], nota[0]);
  not_gate not_gate2(a[1], nota[1]);
  not_gate not_gate3(b[0], notb[0]);
  not_gate not_gate4(b[1], notb[1]);

  wire [4:0] temp1;

  and_gate_4 and_gate1(nota[1], nota[0], b[1], notb[0],temp1[0]);
  and_gate_4 and_gate2(nota[1], a[0], notb[1], b[0], temp1[1]);
  and_gate_4 and_gate3(a[1], nota[0], notb[1], notb[0], temp1[2]);

  or_gate or_gate1(temp1[0], temp1[1], temp1[3]);
  or_gate or_gate2(temp1[2], temp1[3], out[0]);

  wire [4:0] temp;

  and_gate_4 and_gate4(nota[1], a[0],  b[1],notb[0], temp[0]);
  and_gate_4 and_gate5( a[1], nota[0], notb[1], b[0], temp[1]);
  and_gate_4 and_gate6( a[1], nota[0],  b[1], notb[0], temp[2]);

  or_gate or_gate3(temp[0], temp[1], temp[3]);
  or_gate or_gate4(temp[2], temp[3], out[1]);

  // TODO: implementation
endmodule
module and_gate_4(a1, a2, b1, b2, out);
  input wire a1, a2, b1, b2;
  output wire out;
  
  wire [1:0] temp;

  and_gate and_gate7(a1, a2, temp[0]);
  and_gate and_gate8(temp[0], b1, temp[1]);
  and_gate and_gate9(temp[1], b2, out);
endmodule

module ternary_consensus(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;
  
  wire nota0;
  wire notb0;
  wire prv;
  wire bim;
  wire nota1;
  wire notb1;
  wire sum1;
  wire sum2;
  wire sum1233;
  wire sum11;
  wire sum223;
  wire sum22;

  not_gate not_gate1(a[0], nota0);
  not_gate not_gate2(b[0], notb0);
  not_gate not_gate3(a[1], nota1);
  not_gate not_gate4(b[1], notb1);

  and_gate and_gate1(a[1], nota0, prv);
  and_gate and_gate2(b[1], notb0, bim);
  and_gate and_gate3(prv, bim, out[1]);

  or_gate or_gate1(a[1], a[0], sum1);
  or_gate or_gate2(b[1], b[0], sum2);
  or_gate or_gate3(sum1, sum2, sum1233);

  or_gate or_gate4(nota1, a[0], sum11);
  or_gate or_gate5(notb1, b[0], sum223);
  or_gate or_gate6(sum11, sum223, sum22);

  and_gate and_gate4(sum1233, sum22, out[0]);
  // TODO: implementation
endmodule

module not_gate(a, out);
  input wire a;
  output out;

  supply1 pwr;
  supply0 gnd;

  pmos pmos1(out, pwr, a);
  nmos nmos1(out, gnd, a);
endmodule

module and_gate(a, b, out); 
  input wire a, b;
  output wire out;
  wire nand_out;
  nand_gate nand_gate1(a, b, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

module nand_gate(a, b, out); 
  input wire a, b;
  output out;

  supply1 pwr;
  supply0 gnd;

  wire nmos1_out;

  pmos pmos1(out, pwr, a);
  pmos pmos2(out, pwr, b);

  nmos nmos1(nmos1_out, gnd, b);
  nmos nmos2(out, nmos1_out, a);
endmodule

module nor_gate(a, b, out); 
  input wire a, b;
  output out; 

  wire c1; 

  supply1 pwr; 
  supply0 gnd;

  pmos(c1, pwr, b); 
  pmos(out, c1, a); 

  nmos(out, gnd, a); 
  nmos(out, gnd, b);
endmodule

module or_gate(a, b, out);
  input wire a, b;
  output wire out;
  wire nand_out;
  nor_gate nor_gate1(a, b, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule