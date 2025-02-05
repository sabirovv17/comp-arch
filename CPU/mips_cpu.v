`include "util.v"

module mips_cpu(
  clk, pc, pc_new, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
  register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2
);

  // сигнал синхронизации
  input clk;
  // текущее значение регистра PC
  inout [31:0] pc;
  // новое значение регистра PC (адрес следующей команды)
  output [31:0] pc_new;
  // we для памяти данных
  output data_memory_we;
  // адреса памяти и данные для записи памяти данных
  output [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
  // данные, полученные в результате чтения из памяти
  inout [31:0] instruction_memory_rd, data_memory_rd;
  // we3 для регистрового файла
  output register_we3;
  // номера регистров
  output [4:0] register_a1, register_a2, register_a3;
  // данные для записи в регистровый файл
  output [31:0] register_wd3;
  // данные, полученные в результате чтения из регистрового файла
  inout [31:0] register_rd1, register_rd2;

  wire [5:0] operationCode = instruction_memory_rd[31:26];
  wire [5:0] func = instruction_memory_rd[5:0];
  wire [4:0] rnw1 = instruction_memory_rd[20:16];
  wire [4:0] rnw2 = instruction_memory_rd[15:11];
  wire [15:0] tempConst = instruction_memory_rd[15:0];
  wire [25:0] jump = instruction_memory_rd[25:0];
  wire [2:0] checking;

  wire memoR, memoW, bne, beq, data, final, writer, change, link, registr;
  signalch CU(
    operationCode, func, memoR, memoW, bne, 
    beq, data, final, writer, checking, change, link, registr
  );

  assign register_a1 = instruction_memory_rd[25:21];
  assign register_a2 = instruction_memory_rd[20:16];
  wire [4:0] tempWriter;
  mux2_5 output1(rnw1, rnw2, final, tempWriter);
  mux2_5 output2(tempWriter, 5'b11111, link, register_a3);

  wire [31:0] const;
  assign const = {6'b000000, instruction_memory_rd[15:0]};
  sign_extend de(tempConst, const);

  wire [31:0] input1 = register_rd1;
  wire [31:0] input2;
  mux2_32 secondOperand(.d0(register_rd2), .d1(const), .a(data), .out(input2));

  wire [31:0] res;
  wire zero;
  alu al1(input1, input2, checking, res, zero);

  assign instruction_memory_a = pc;

  assign register_we3 = writer;
  assign data_memory_a = res;
  assign data_memory_wd = register_rd2;
  assign data_memory_we = memoW;
  wire [31:0] a;
  mux2_32 writer1(res, data_memory_rd, memoR, a);
  mux2_32 writer2(a, pcinit, link, register_wd3);

  wire [31:0] pcinit;
  wire [31:0] pc1;
  wire [31:0] constatna;
  shl_2 aa1(const, constatna);
  wire inp, inp2;
  alu alu1(pc, 4, 3'b010, pcinit, inp1);
  alu alu2(pcinit, constatna, 3'b010, pc1, inp2);

  wire zaza;

  mux mux1(bne, beq, zero, zaza);

  wire ch;
  assign ch = !zero;
  
  wire ch2;
  mux mx2(ch, zero, beq, ch2);

  wire ass;
  and_gate n1(zaza, ch2, ass);

  wire [31:0] tempPc;

  mux2_32 choosePc(pcinit, pc1, ass, tempPc);

  wire [31:0] tempChange;
  assign tempChange = {jump, 6'b00};

  wire [31:0] jumpa;
  shl_2 b1(tempChange, jumpa);

  wire [31:0] tempPckek;

  mux2_32 choosePc1(tempPc, jumpa, change, tempPckek);
  mux2_32 choosePc2(tempPckek, input1, registr, pc_new);
endmodule

module alu(input1, input2, control, res, zero);
  input signed [31:0] input1, input2;
  input [2:0] control;
  output reg [31:0] res;
  output reg zero;
  always @(control or input1 or input2) begin
    case (control[1:0])
      0: 
         res = input1 & (control[2] ? ~input2 : input2);
      1: 
         res = input1 | (control[2] ? ~input2 : input2);
      2: 
         res = input1 + (control[2] ? ~input2 : input2) + control[2];
      3: 
         res = (input1 < input2) ? 1 : 0;
    endcase

    zero = ~(|res);
  end
endmodule

module and_gate(input input1, input2, output reg out);
  always @(input1 or input2) begin
    out = input1 && input2;
  end
endmodule

module signalch(operationCode, func, memoR, memoW, bne, beq, data, final, writer, checking, change, link, registr);
  input wire [5:0] operationCode, func;
  output wire memoR, memoW, bne, beq, data, final, writer, change, link, registr;
  output reg [2:0] checking;

  reg tempMemoR, tempMemoW, tempBne, tempBeq, tempData, tempFinal, tempWriter, tempChange, tempLink, tempRegistr;

  always @* begin
    tempWriter = 0; tempFinal = 0; tempData = 0; tempMemoR = 0; tempLink = 0;
    tempBne = 0; tempBeq = 0; tempMemoW = 0; tempChange = 0; tempRegistr = 0;
    checking = 3'b000;
    case (operationCode)
      0: begin
        tempWriter = 1; tempFinal = 1; checking = 3'b010;
      end
      2: begin
        checking = 3'b010; tempChange = 1;
      end
      3: begin
        tempWriter = 1; tempLink = 1; checking = 3'b010; tempChange = 1;
      end
      4: begin
        tempBeq = 1; checking = 3'b001;
      end
      5: begin
        tempBne = 1; checking = 3'b001;
      end
      8: begin
        tempWriter = 1; tempData = 1;
      end
      12: begin
        tempWriter = 1; tempData = 1; checking = 3'b011;
      end
      35: begin
        tempWriter = 1; tempData = 1; tempMemoR = 1;
      end
      43: begin
       tempData = 1; tempMemoW = 1;
      end
      default: checking = 3'b000;
    endcase

    if (checking == 3'b000) checking = 3'b010;
    else if (checking == 3'b011) checking = 3'b000;
    else if (checking == 3'b001) checking = 3'b110;
    
    else begin
      case (func)
        6'b100000: checking = 3'b010;
        6'b100010: checking = 3'b110;
        6'b100100: checking = 3'b000;
        6'b100101: checking = 3'b001;
        6'b101010: checking = 3'b111;
        6'b001000: begin
          tempRegistr = 1;
          tempWriter = 0;
        end
        default: checking = 3'b000;
      endcase
    end
  end

  assign memoR = tempMemoR;
  assign final = tempFinal;
  assign data = tempData;
  assign beq = tempBeq;
  assign memoW = tempMemoW;
  assign bne = tempBne;
  assign change = tempChange;
  assign link = tempLink;
  assign writer = tempWriter;
  assign registr = tempRegistr;
endmodule

module mux(input d0, d1, input1, output out);
  assign out = input1 ? d1 : d0;
endmodule