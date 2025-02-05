module alu(a, b, control, res);
  input [3:0] a, b; // Операнды
  input [2:0] control; // Управляющие сигналы для выбора операции

  output [3:0] res; // Результат

  wire [3:0] AandB;
  wire [3:0] nAandB;
  wire [3:0] AorB;
  wire [3:0] nAorB;
  wire [3:0] AplB;
  wire [3:0] AmnB;
  wire c1, c2, c3, c4, f1, f2, f3, f4, notb0, notb1, notb2, notb3, slt, nAmnB, x;
  wire z0 = 0;
  wire z1 = 1;

  and_gate and_gate1(a[0], b[0], AandB[0]);
  and_gate and_gate2(a[1], b[1], AandB[1]);
  and_gate and_gate3(a[2], b[2], AandB[2]);
  and_gate and_gate4(a[3], b[3], AandB[3]);

  not_gate not_gate1(AandB[0], nAandB[0]);
  not_gate not_gate2(AandB[1], nAandB[1]);
  not_gate not_gate3(AandB[2], nAandB[2]);
  not_gate not_gate4(AandB[3], nAandB[3]);

  or_gate or_gate1(a[0], b[0], AorB[0]);
  or_gate or_gate2(a[1], b[1], AorB[1]);
  or_gate or_gate3(a[2], b[2], AorB[2]);
  or_gate or_gate4(a[3], b[3], AorB[3]);

  not_gate nor_gate5(AorB[0], nAorB[0]);
  not_gate nor_gate6(AorB[1], nAorB[1]);
  not_gate nor_gate7(AorB[2], nAorB[2]);
  not_gate nor_gate8(AorB[3], nAorB[3]);

  fullsum_gate fullsum_gate1(a[0], b[0], z0, AplB[0], c1);
  fullsum_gate fullsum_gate2(a[1], b[1], c1, AplB[1], c2);
  fullsum_gate fullsum_gate3(a[2], b[2], c2, AplB[2], c3);
  fullsum_gate fullsum_gate4(a[3], b[3], c3, AplB[3], c4);

  not_gate not_gate9(b[0], notb0);
  not_gate not_gate10(b[1], notb1);
  not_gate not_gate11(b[2], notb2);
  not_gate not_gate12(b[3], notb3);

  fullsum_gate fullsum_gate5(a[0], notb0, z1, AmnB[0], f1);
  fullsum_gate fullsum_gate6(a[1], notb1, f1, AmnB[1], f2);
  fullsum_gate fullsum_gate7(a[2], notb2, f2, AmnB[2], f3);
  fullsum_gate fullsum_gate8(a[3], notb3, f3, AmnB[3], f4);

  wire k1,k2,k3,k4,k33,k44;
  wire more1,more2,more3,more4;
  
  not_gate not_gate13(AmnB[3], nAmnB);
  not_gate not_gate14(a[3], k1);
  not_gate not_gate15(b[3], k2);
  
  and_gate and_gate99(a[3],k2,k3);
  and_gate and_gate98(b[3],k1,k4);
  not_gate not_gate16(k3, k33);
  not_gate not_gate17(k4, k44);
  and4_gate and_gate41(k44,z1,nAmnB,k3,more1);
  and4_gate and_gate42(k44,z1,AmnB[3],k33,more2);
  and4_gate and_gate43(k44,z1,AmnB[3],k3,more3);
  or_gate or_gate41(more1,more2,more4);
  or_gate or_gate42(more3,more4,slt);

  //========================================================================================

  multiplexor_gate multiplexor_gate1(AandB[0], nAandB[0], AorB[0], nAorB[0], AplB[0], AmnB[0], slt, z0, control, res[0]);
  multiplexor_gate multiplexor_gate2(AandB[1], nAandB[1], AorB[1], nAorB[1], AplB[1], AmnB[1], z0, z0, control, res[1]);
  multiplexor_gate multiplexor_gate3(AandB[2], nAandB[2], AorB[2], nAorB[2], AplB[2], AmnB[2], z0, z0, control, res[2]);
  multiplexor_gate multiplexor_gate4(AandB[3], nAandB[3], AorB[3], nAorB[3], AplB[3], AmnB[3], z0, z0, control, res[3]);
  // TODO: implementation
endmodule

module d_latch(clk, d, we, q);
  input clk; // Сигнал синхронизации
  input d; // Бит для записи в ячейку
  input we; // Необходимо ли перезаписать содержимое ячейки

  output reg q; // Сама ячейка
  // Изначально в ячейке хранится 0
  initial begin
    q <= 0;
  end
  // Значение изменяется на переданное на спаде сигнала синхронизации
  always @ (negedge clk) begin
    // Запись происходит при we = 1
    if (we) begin
      q <= d;
    end
  end
endmodule

module register_file(clk, rd_addr, we_addr, we_data, rd_data, we);
  input clk; // Сигнал синхронизации
  input [1:0] rd_addr, we_addr; // Номера регистров для чтения и записи
  input [3:0] we_data; // Данные для записи в регистровый файл
  input we; // Необходимо ли перезаписать содержимое регистра
  output [3:0] rd_data; // Данные, полученные в результате чтения из регистрового файла
  wire [3:0] buff;
  wire [3:0] out;
  wire [3:0] w;
  wire [15:0] trd;
  wire [15:0] rd;
  wire not0, notb1;

  not_gate not_gate1(we_addr[0], not0);
  not_gate not_gate2(we_addr[1], not1);

  and_gate and_gate1(not0, not1, buff[0]);
  and_gate and_gate2(not0, we_addr[1], buff[1]);
  and_gate and_gate3(we_addr[0], not1, buff[2]);
  and_gate and_gate4(we_addr[0], we_addr[1], buff[3]);

  not_gate not_gate3(rd_addr[0], notr0);
  not_gate not_gate4(rd_addr[1], notr1);

  and_gate and_gate11(notr0, notr1, out[0]);
  and_gate and_gate22(notr0, rd_addr[1], out[1]);
  and_gate and_gate33(rd_addr[0], notr1, out[2]);
  and_gate and_gate44(rd_addr[0], rd_addr[1], out[3]);

  and_gate and_gate5(we, buff[0], w[0]);
  and_gate and_gate6(we, buff[1], w[1]);
  and_gate and_gate7(we, buff[2], w[2]);
  and_gate and_gate8(we, buff[3], w[3]);
  
  d_latch d0(clk, we_data[0], w[0], trd[0]);
  d_latch d1(clk, we_data[1], w[0], trd[1]);
  d_latch d2(clk, we_data[2], w[0], trd[2]);
  d_latch d3(clk, we_data[3], w[0], trd[3]);
  d_latch d4(clk, we_data[0], w[1], trd[4]);
  d_latch d5(clk, we_data[1], w[1], trd[5]);
  d_latch d6(clk, we_data[2], w[1], trd[6]);
  d_latch d7(clk, we_data[3], w[1], trd[7]);
  d_latch d8(clk, we_data[0], w[2], trd[8]);
  d_latch d9(clk, we_data[1], w[2], trd[9]);
  d_latch d10(clk, we_data[2], w[2], trd[10]);
  d_latch d11(clk, we_data[3], w[2], trd[11]);
  d_latch d12(clk, we_data[0], w[3], trd[12]);
  d_latch d13(clk, we_data[1], w[3], trd[13]);
  d_latch d14(clk, we_data[2], w[3], trd[14]);
  d_latch d15(clk, we_data[3], w[3], trd[15]);

  and_gate and_gate9(trd[0], out[0], rd[0]);
  and_gate and_gate10(trd[1], out[0], rd[1]);
  and_gate and_gate11(trd[2], out[0], rd[2]);
  and_gate and_gate12(trd[3], out[0], rd[3]);
  and_gate and_gate13(trd[4], out[1], rd[4]);
  and_gate and_gate14(trd[5], out[1], rd[5]);
  and_gate and_gate15(trd[6], out[1], rd[6]);
  and_gate and_gate16(trd[7], out[1], rd[7]);
  and_gate and_gate17(trd[8], out[2], rd[8]);
  and_gate and_gate18(trd[9], out[2], rd[9]);
  and_gate and_gate19(trd[10], out[2], rd[10]);
  and_gate and_gate20(trd[11], out[2], rd[11]);
  and_gate and_gate21(trd[12], out[3], rd[12]);
  and_gate and_gate22(trd[13], out[3], rd[13]);
  and_gate and_gate23(trd[14], out[3], rd[14]);
  and_gate and_gate24(trd[15], out[3], rd[15]);

  wire f1, f2, f3, f4, f5, f6, f7, f8;

  or_gate or_gate1(rd[0], rd[4], f1);
  or_gate or_gate2(rd[8], rd[12], f2);
  or_gate or_gate3(f1, f2, rd_data[0]);

  or_gate or_gate4(rd[1], rd[5], f3);
  or_gate or_gate5(rd[9], rd[13], f4);
  or_gate or_gate6(f3, f4, rd_data[1]);

  or_gate or_gate7(rd[2], rd[6], f5);
  or_gate or_gate8(rd[10], rd[14], f6);
  or_gate or_gate9(f5, f6, rd_data[2]);

  or_gate or_gate10(rd[3], rd[7], f7);
  or_gate or_gate11(rd[11], rd[15], f8);
  or_gate or_gate12(f7, f8, rd_data[3]);
  // TODO: implementation
endmodule

module counter(clk, addr, control, immediate, data);
  input clk; // Сигнал синхронизации
  input [1:0] addr; // Номер значения счетчика которое читается или изменяется
  input [3:0] immediate; // Целочисленная константа, на которую увеличивается/уменьшается значение счетчика
  input control; // 0 - операция инкремента, 1 - операция декремента
  output [3:0] data; // Данные из значения под номером addr, подающиеся на выход
  wire[3:0] f1, f2;

  wire one = 1;
  register_file file(clk, addr, addr, f1, f2, one);

  wire[2:0] element = {2'b10, control};

  alu alu1(f2, immediate, element, f1);
  assign data = f2;
endmodule

module not_gate(a, out); // not 
  input wire a;
  output out;

  supply1 pwr;
  supply0 gnd;

  pmos pmos1(out, pwr, a);
  nmos nmos1(out, gnd, a);
endmodule

module and_gate(a, b, out); // and
  input wire a, b;
  output wire out;
  wire nand_out;
  nand_gate nand_gate1(a, b, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

module and4_gate(a, b, c, d, out); // and4
  input wire a, b, c, d;
  output wire out;
  wire c1, c2;
  and_gate and_gate1(a, b, c1);
  and_gate and_gate2(c, d, c2);
  and_gate and_gate3(c1, c2, out);
endmodule

module nand_gate(a, b, out); // Стрелка шифера
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

module xor_gate(a, b, out);
  input wire a, b;
  output wire out;

  wire nota;
  wire notb;
  wire c1;
  wire c2;

  not_gate not_gate1(a, nota);
  not_gate not_gate2(b, notb);

  and_gate and_gate1(a, notb, c1);
  and_gate and_gate2(nota, b, c2);

  or_gate or_gate1(c1, c2, out);
endmodule

module fullsum_gate(a, b, C, out, outC);
  input  a, b, C;
  output  out, outC;

  wire x1;
  wire A1;
  wire A2;
  
  xor_gate xor_gate1(a, b, x1);
  xor_gate xor_gate2(x1, C, out);

  and_gate and_gate1(a, b, A1);
  and_gate and_gate2(x1, C, A2);

  or_gate or_gate1(A1, A2, outC);
endmodule

module ml_gate(a, b, x, out);
  input wire a, b, x;
  output wire out;
  wire notx, j1, j2;
  
  not_gate not_gate1(x, notx);
  and_gate and_gate2(a, x, j1);
  and_gate and_gate3(b, notx, j2);
  or_gate or_gate1(j1, j2, out);
endmodule

module multiplexor_gate(oper1,oper2,oper3,oper4,oper5,oper6,oper7,oper8,control,out);
  input oper1,oper2,oper3,oper4,oper5,oper6,oper7,oper8;
  input [2:0] control;
  output out;

  wire a,b,c;
  wire x1,x2,x3,x4,x5,x6,x7,x8;

  not_gate not_gate1(control[0],c);
  not_gate not_gate2(control[1],b);
  not_gate not_gate3(control[2],a);
  and4_gate and4_gate1(oper1,a,b,c,x1);
  and4_gate and4_gate2(oper2,a,b,control[0],x2);
  and4_gate and4_gate3(oper3,a,control[1],c,x3);
  and4_gate and4_gate4(oper4,a,control[1],control[0],x4);
  and4_gate and4_gate5(oper5,control[2],b,c,x5);
  and4_gate and4_gate6(oper6,control[2],b,control[0],x6);
  and4_gate and4_gate7(oper7,control[2],control[1],c,x7);
  and4_gate and4_gate8(oper8,control[2],control[1],control[0],x8);

  wire z1,z2,z3,z4,z5,z6;

  or_gate or_gate1(x1, x2, z1);
  or_gate or_gate2(x3, x4, z2);
  or_gate or_gate3(x5, x6, z3);
  or_gate or_gate4(x7, x8, z4);
  or_gate or_gate5(z1, z2, z5);
  or_gate or_gate6(z3, z4, z6);
  or_gate or_gate7(z6, z5, out);
endmodule