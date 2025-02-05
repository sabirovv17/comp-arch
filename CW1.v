module implication_mos(a, b, out);
  input a, b;
  output out;
  wire inv;
  not_gate not1(a,inv);
  or_gate or1(b, inv,out); 
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

module implication_mos(a, b, out);
    input a, b;
    output out;
    wire nota;

    not_gate not_gate1(a, nota);
    or_gate or1(nota, b, out);
endmodule