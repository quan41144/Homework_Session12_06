create database Homework_session12_06;
-- Tạo bảng accounts:
create table accounts(
	account_id serial primary key,
	account_name varchar(50),
	balance numeric
);
-- Thêm 10 bản ghi vào accounts với số dư ban đầu
insert into accounts (account_name, balance) values
('Nguyen Van A', 1500.00),
('Tran Thi B', 2500.50),
('Le Van C', 500.25),
('Pham Minh D', 10000.00),
('Hoang Thi E', 75.00),
('Doan Van F', 3200.00),
('Vu Thi G', 1250.75),
('Dang Van H', 900.00),
('Bui Thi I', 4500.60),
('Ngo Van K', 150.00);
-- Viết một transaction
create or replace procedure acc_process(
	p_acc_id_01 int,
	p_acc_id_02 int,
	amount numeric
)
language plpgsql
as $$
declare
	v_balance_01 numeric;
begin
	select balance into v_balance_01 from accounts where account_id = p_acc_id_01;
	-- Kiểm tra số dư tài khoản gửi
	-- Nếu đủ tiền, trừ số tiền từ tài khoản gửi, cộng vào tài khoản nhận và COMMIT
	if amount <= v_balance_01 then
		update accounts set balance = balance - amount where account_id = p_acc_id_01;
		update accounts set balance = balance + amount where account_id = p_acc_id_02;
	-- Nếu không đủ tiền, ROLLBACK
	else 
		raise exception 'Giao dịch không thành công! Số dư của bạn không đủ!';
	end if;
exception
	when others then
	raise notice 'Đã xảy ra lỗi!';
	raise;
end;
$$;
-- Thực hành chuyển tiền hợp lệ và không hợp lệ, quan sát kết quả trên bảng accounts
call acc_process(1, 2, 1500);
call acc_process(3, 4, 600);
select * from accounts;