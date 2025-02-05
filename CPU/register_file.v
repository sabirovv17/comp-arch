module register_file(clk, we3, a1, a2, a3, wd3, rd1, rd2);
  // we3 - флаг записи регистра под номером a3
  // clk - сигнал синхронизации
  input clk, we3;
  // номера регистров
  // a1, a2 - номера регистров для чтения
  // a3 - номер регистра для записи
  input [4:0] a1, a2, a3;
  // данные для записи в регистра с номером a3
  input [31:0] wd3;
  // данные, полученные в результате чтения
  // из регистров с номерами a1 и a2
  output [31:0] rd1, rd2;

  // непосредственно регистры, 32 регистра по 32 бита
  reg [31:0] mem[0:31];

  // изначально регистры заполняются нулями
  integer i;
  initial begin
    for (i = 0; i < 32; i = i + 1) begin
      mem[i] = 0;
   	end
  end

  // чтение регистров
  assign rd1 = mem[a1];
  assign rd2 = mem[a2];

  // запись на фронте сигнала синхронизации
  always @ (posedge clk) begin
    // при we3 = 1
    if (we3) mem[a3] = wd3;
  end
endmodule
