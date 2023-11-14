use starknet::{ContractAddress,get_caller_address,Store,SyscallResult,StorageBaseAddress,storage_read_syscall, storage_write_syscall,
    storage_address_from_base_and_offset,};
use array::ArrayTrait;
use hash::{HashStateTrait,Hash};

#[starknet::interface]
#[derive(Drop,Copy,Serde,Hash)]
    struct Book{
        Title:felt252,
    }
trait DatabaseTrait<T> {
    fn display_books(self:@T)->Array<felt252>;

    fn add_book(ref self:T,key:Book);

    fn search_book(self:@T,key:Book)->felt252;

    fn delete_book(ref self:T,bk_title:felt252);
}


impl StoreFelt252Array of Store<Array<felt252>> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult<Array<felt252>> {
        StoreFelt252Array::read_at_offset(address_domain, base, 0)
    }

    fn write(
        address_domain: u32, base: StorageBaseAddress, value: Array<felt252>
    ) -> SyscallResult<()> {
        StoreFelt252Array::write_at_offset(address_domain, base, 0, value)
    }

    fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8
    ) -> SyscallResult<Array<felt252>> {
        let mut arr: Array<felt252> = ArrayTrait::new();

        // Read the stored array's length. If the length is superior to 255, the read will fail.
        let len: u8 = Store::<u8>::read_at_offset(address_domain, base, offset)
            .expect('Storage Span too large');
        offset += 1;

        // Sequentially read all stored elements and append them to the array.
        let exit = len + offset;
        loop {
            if offset >= exit {
                break;
            }

            let value = Store::<felt252>::read_at_offset(address_domain, base, offset).unwrap();
            arr.append(value);
            offset += Store::<felt252>::size();
        };

        // Return the array.
        Result::Ok(arr)
    }

    fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8, mut value: Array<felt252>
    ) -> SyscallResult<()> {
        // // Store the length of the array in the first storage slot.
        let len: u8 = value.len().try_into().expect('Storage - Span too large');
        Store::<u8>::write_at_offset(address_domain, base, offset, len);
        offset += 1;

        // Store the array elements sequentially
        loop {
            match value.pop_front() {
                Option::Some(element) => {
                    Store::<felt252>::write_at_offset(address_domain, base, offset, element);
                    offset += Store::<felt252>::size();
                },
                Option::None(_) => { break Result::Ok(()); }
            };
        }
    }

    fn size() -> u8 {
        255 * Store::<felt252>::size()
    }
}


#[starknet::contract]
mod add_book{
    use super::StoreFelt252Array;
    use starknet::get_caller_address;
    use super::Book;
    use starknet::ContractAddress;


    #[storage]
    struct Storage {
        Books:LegacyMap::<Book,felt252>,
        arr:Array<felt252>,
        admin:LegacyMap::<ContractAddress,bool>,
        student:LegacyMap::<ContractAddress,bool>,
    }

#[constructor]
fn constructor(ref self: ContractState,admin_1:ContractAddress,
student_1:ContractAddress,
student_2:ContractAddress,
student_3:ContractAddress){

    self.create_admin(admin_1);
    self.create_student(student_1,student_2,student_3);

    let book1 = Book{Title:'Be Rich',};
    let book2 = Book{Title:'1000 ways',};
    let book3 = Book{Title:'Influence People',};
    let book4 = Book{Title:'Lorem Ipsum',};
    let book5 = Book{Title:'Hello world',};

    self.Books.write(book1,book1.Title);
    self.Books.write(book2,book2.Title);
    self.Books.write(book3,book3.Title);
    self.Books.write(book4,book4.Title);
    self.Books.write(book5,book5.Title);
}

#[event]
#[derive(Drop,starknet::Event)]
enum Event{
    IllegalAdd:IllegalAdd,
}

#[derive(Drop,starknet::Event)]
struct IllegalAdd{
    illegal_admin:ContractAddress,
}

#[external(v0)]
#[abi(embed_v0)]
impl DataBaseTraitImpl of super::DatabaseTrait<ContractState>{
    fn add_book(ref self: ContractState,key:Book){

        let caller:ContractAddress = get_caller_address();

        self.is_an_admin(caller);

        self.Books.write(key,key.Title); //writes a book struct as key, and title as value
        let mut count:u32 = 0;
        let mut arr2:Array<felt252> = ArrayTrait::new();
        count+=1;
        let mut bk:felt252= self.Books.read(key);
        arr2.append(bk);
        self.arr.write(arr2);
    }
    fn display_books(self:@ContractState)->Array<felt252>{
        let mut arr2=ArrayTrait::<felt252>::new();
        arr2=self.arr.read();
        return arr2;
    }
    fn search_book(self:@ContractState,key:Book)->felt252{
       let found_book = self.Books.read(key);
        assert(found_book != 0, 'BOOK NOT FOUND');
        if found_book != 0 {
            return found_book;
        }
        let no_book:felt252 = 'no book';
        return no_book;
    }

    fn delete_book(ref self:ContractState,bk_title:felt252){
        let bk_struct:Book = Book{Title:bk_title,};
        let del_book = self.Books.read(bk_struct);
        assert(del_book != 0,'BOOK DOES NOT EXIST');

        let caller:ContractAddress = get_caller_address();
        self.is_an_admin(caller);

        self.Books.write(bk_struct,' ');

        let mut arr2=ArrayTrait::<felt252>::new();
        arr2=self.arr.read();
        let len = arr2.len();
    }

}

#[generate_trait]
impl InternalFunctions of InternalFunctionsTrait{

    fn create_admin(ref self:ContractState,
    admin_1:ContractAddress){
        self.admin.write(admin_1,true);
    }


    fn create_student(ref self:ContractState,
    student_1:ContractAddress,
    student_2:ContractAddress,
    student_3:ContractAddress){
        self.student.write(student_1,true);
        self.student.write(student_2,true);
        self.student.write(student_3,true)
    }


}

//Asserts implementation of the add_book function
#[generate_trait]
impl AssertsImpl of AssertsImplTrait{
    fn is_an_admin(ref self:ContractState,address:ContractAddress){
        let is_admin:bool = self.admin.read((address));

        if(is_admin == false){
            self.emit( IllegalAdd {illegal_admin:address,});
        }

        assert(is_admin == true, 'ONLY ADMINS CAN ADD/DELETE BOOK');

    }
}


}
