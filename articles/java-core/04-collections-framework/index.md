---
title: "Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue"
description: "Collection, List, Set, Queue, Deque và Map theo The Java Tutorials, cùng hợp đồng hiệu năng của ArrayList, LinkedList và HashMap trên Java SE 25."

date:
updated:

series: "Java Core"
series_order: 4

tags:
  - java
  - collections
  - hashmap
  - data-structures

status: draft
language: vi
---

# Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue

> **Tóm tắt:** Collections Framework là các interface, implementation và algorithm dùng chung. `Map` không phải `Collection`. `ArrayList`, `LinkedList` và `HashMap` trên Java SE 25 đều không synchronized, và mỗi class ghi rõ thao tác nào là thời gian hằng, thao tác nào phải đi dọc danh sách.

*Thời gian đọc: ~10 phút*

---

## 1. Ba mảnh của một framework

Một collection, đôi khi gọi là container, là một object gom nhiều phần tử vào một đơn vị. Nó dùng để cất, lấy, thao tác và truyền dữ liệu gộp. Tutorial đưa ví dụ một tay bài, một thư mục thư, hoặc một danh bạ ánh xạ tên sang số điện thoại.

Một collections framework là kiến trúc thống nhất để biểu diễn và thao tác collection. Mọi framework dạng này có ba phần:

- Interface: abstract data type biểu diễn collection. Nhờ interface, mình thao tác collection mà không phụ thuộc cách nó được biểu diễn. Trong ngôn ngữ hướng đối tượng, interface thường thành một hierarchy.
- Implementation: hiện thực cụ thể của các interface đó, tức cấu trúc dữ liệu dùng lại được.
- Algorithm: method tính toán trên object implement collection interface, như tìm và sắp xếp. Algorithm được gọi là polymorphic: cùng một method dùng được trên nhiều implementation của interface phù hợp.

Java Collections Framework giảm việc phải viết cấu trúc dữ liệu và adapter giữa các API không liên quan. Các implementation của cùng một interface thay được cho nhau, nên chương trình chỉnh bằng cách đổi implementation. Interface collection là ngôn ngữ chung để các API trao collection. API mới nhận hoặc trả collection thì dùng interface chuẩn, không bịa một sub-API riêng. Cấu trúc dữ liệu mới mà theo interface chuẩn thì dùng lại được. Algorithm mới trên các object implement interface đó cũng vậy.

Trang giới thiệu được viết cho JDK 8. Phần implementation bên dưới mình lấy từ tài liệu API Java SE 25, vì đó là hợp đồng của `ArrayList`, `LinkedList` và `HashMap` hiện tại.

---

## 2. Hai cây interface

Core collection interface là nền của framework. Hierarchy có hai cây tách nhau. `Map` không phải một `Collection`.

Mọi core collection interface đều generic. Khai báo một `Collection` thì mình nên chỉ kiểu phần tử. Compiler kiểm tra lúc biên dịch rằng object đưa vào đúng kiểu, và nhờ đó giảm lỗi lúc chạy.

Để không phải có một interface cho mỗi biến thể, các thao tác sửa được đánh dấu *optional*. Implementation có thể không hỗ trợ hết. Gọi thao tác không được hỗ trợ thì collection ném `UnsupportedOperationException`. Implementation phải ghi nó hỗ trợ thao tác optional nào. Mọi general-purpose implementation của nền tảng Java hỗ trợ hết các thao tác optional.

| Interface | Trang Interfaces nói gì |
| --- | --- |
| `Collection` | Gốc của hierarchy. Nhóm các object gọi là element. Nền tảng không có implementation trực tiếp. Có implementation của subinterface cụ thể hơn, như `Set` và `List`. |
| `Set` | Không chứa phần tử trùng. Mô hình tập hợp toán học. |
| `List` | Collection có thứ tự, đôi khi gọi là sequence. Được chứa phần tử trùng. Chèn đúng chỗ và truy cập bằng chỉ số nguyên. |
| `Queue` | Giữ nhiều phần tử trước khi xử lý. Thêm thao tác chèn, lấy ra và xem. Thường FIFO, nhưng không bắt buộc. Priority queue xếp theo comparator được cung cấp hoặc theo natural ordering. Head là phần tử mà `remove` hoặc `poll` sẽ lấy. Mọi implementation phải nêu tính chất thứ tự của nó. |
| `Deque` | Dùng được như FIFO và như LIFO. Phần tử mới được chèn, lấy và xóa ở cả hai đầu. |
| `Map` | Ánh xạ key sang value. Không có key trùng. Mỗi key ánh xạ tới nhiều nhất một value. |
| `SortedSet`, `SortedMap` | Bản đã sắp của `Set` và `Map`, giữ phần tử hoặc key theo thứ tự tăng. |

`Set` là một dạng `Collection`. `SortedSet` là một dạng `Set`. `SortedMap` là bản `Map` tương ứng của `SortedSet`.

---

## 3. `ArrayList` và `LinkedList` không cùng một giá

`ArrayList` là hiện thực `List` bằng mảng co giãn. Nó implement mọi thao tác list optional và cho phép mọi phần tử, kể cả `null`. Class này gần với `Vector`, trừ việc nó không synchronized. Nó còn implement `RandomAccess`, `Cloneable` và `Serializable`.

`size`, `isEmpty`, `get`, `set`, `getFirst`, `getLast`, `removeLast`, `iterator`, `listIterator` và `reversed` chạy trong constant time. `add` và `addLast` chạy trong *amortized* constant time: thêm n phần tử cần O(n). Các thao tác còn lại chạy trong linear time, nói một cách gần đúng. Hệ số hằng thấp hơn implementation `LinkedList`.

Mỗi instance có *capacity*, là kích thước mảng dùng để cất phần tử. Capacity luôn ít nhất bằng size của list. Thêm phần tử thì capacity tự tăng. Chính sách tăng không được đặc tả ngoài việc thêm một phần tử có chi phí amortized constant time. `ensureCapacity` tăng capacity trước khi thêm một lượng lớn phần tử, để giảm cấp phát tăng dần. Constructor không đối số tạo list rỗng với initial capacity là mười. `trimToSize` cắt capacity xuống đúng size hiện tại. `clone` là shallow copy: các phần tử không bị copy.

`get` ném `IndexOutOfBoundsException` nếu index nằm ngoài `index < 0 || index >= size()`. `getFirst` và `getLast` có từ Java SE 21 và ném `NoSuchElementException` nếu collection rỗng.

Implementation này không synchronized. Nhiều thread cùng truy cập, và ít nhất một thread sửa cấu trúc, thì phải synchronized từ bên ngoài. Sửa cấu trúc là thêm hoặc xóa một hay nhiều phần tử, hoặc resize tường minh mảng nền. Chỉ gán giá trị của một phần tử thì không phải sửa cấu trúc. Nếu không có object nào bao list một cách tự nhiên, bọc bằng `Collections.synchronizedList`.

`LinkedList` là doubly-linked list của cả `List` và `Deque`. Nó cho phép mọi phần tử, kể cả `null`. Mọi thao tác chạy như mình kỳ vọng với một doubly-linked list. Thao tác truy cập theo index đi từ đầu hoặc từ cuối, chọn đầu nào gần index hơn.

Nó cũng không synchronized. Sửa cấu trúc ở đây là thêm hoặc xóa phần tử. Chỉ gán giá trị một phần tử thì không phải sửa cấu trúc. Bọc bằng `Collections.synchronizedList` khi không có object bao ngoài.

`peek` lấy head mà không xóa, trả `null` nếu list rỗng. `element` cũng lấy head mà không xóa, nhưng ném `NoSuchElementException` nếu rỗng. `poll` lấy và xóa head, trả `null` nếu rỗng. `remove()` lấy và xóa head, ném `NoSuchElementException` nếu rỗng. `getFirst` và `getLast` ném `NoSuchElementException` nếu list rỗng. `addLast` tương đương `add`.

Mình không lấy `LinkedList` khi cần `get` theo index ở giữa list. Trang nói thao tác đó phải đi từ đầu hoặc cuối. Mình không lấy `ArrayList` rồi giả định chính sách nhân capacity, vì SE 25 không đặc tả chính sách đó ngoài chi phí amortized constant time của việc thêm một phần tử.

---

## 4. `HashMap` là bảng băm, không phải một thứ tự

`HashMap` implement mọi thao tác map optional, cho phép `null` value và `null` key. Nó gần với `Hashtable`, trừ việc không synchronized và cho phép null. Class không đảm bảo thứ tự của map, và không đảm bảo thứ tự giữ nguyên theo thời gian.

`get` và `put` có constant-time performance, với giả định hash function phân tán phần tử đúng vào các bucket. Duyệt collection view tốn thời gian tỷ lệ với capacity, tức số bucket, cộng với size, tức số ánh xạ. Đặt initial capacity quá cao, hoặc load factor quá thấp, sẽ làm vòng lặp chậm.

Capacity là số bucket. Initial capacity là capacity lúc bảng được tạo. Load factor đo bảng được phép đầy đến đâu trước khi capacity tự tăng. Khi số entry vượt quá tích của load factor và capacity hiện tại, bảng được *rehash*: cấu trúc bên trong được dựng lại để số bucket xấp xỉ gấp đôi.

Load factor mặc định `0.75` được trang gọi là một đánh đổi tốt giữa thời gian và bộ nhớ. Giá trị cao hơn giảm phần bộ nhớ thừa nhưng tăng chi phí tra, kể cả `get` và `put`. Nếu initial capacity lớn hơn số entry tối đa chia cho load factor, sẽ không có lần rehash nào. Constructor không đối số tạo map rỗng với initial capacity `16` và load factor `0.75`. Initial capacity âm, hoặc load factor không dương, thì constructor tương ứng ném `IllegalArgumentException`.

Nhiều key cùng `hashCode()` chắc chắn làm chậm mọi hash table. Khi key là `Comparable`, class này có thể dùng thứ tự so sánh giữa các key để phá hòa. Tài liệu `HashMap` của Java SE 25 ở đoạn này không nói bucket chuyển thành red-black tree. Mình không gắn cơ chế đó vào class.

`get` trả value của key, hoặc `null` nếu không có ánh xạ. So khớp key là `key==null ? k==null : key.equals(k)`. Có nhiều nhất một ánh xạ như vậy. `null` trả về không chắc là key vắng mặt, vì map có thể ánh xạ key tới `null`. `containsKey` phân biệt hai trường hợp đó.

Implementation không synchronized. Nhiều thread truy cập, và ít nhất một thread sửa cấu trúc, thì phải synchronized bên ngoài. Sửa cấu trúc là thêm hoặc xóa một hay nhiều ánh xạ. Chỉ đổi value của một key mà instance đã có thì không phải sửa cấu trúc. Không có object bao map thì bọc bằng `Collections.synchronizedMap`.

`keySet` là view được map chống lưng. Sửa map thì set thấy, và ngược lại. Sửa map trong lúc đang duyệt set, trừ `remove` của chính iterator, thì kết quả duyệt là undefined. Set này không hỗ trợ `add` hay `addAll`.

---

## Kết luận

Mình chọn interface trước, implementation sau. Cần thứ tự và chỉ số thì `List`. Cần không trùng thì `Set`. Cần hàng đợi thì đọc ordering properties của đúng implementation `Queue`, vì FIFO không phải luật của mọi queue. Cần key thì `Map`, và đừng chờ `HashMap` giữ thứ tự chèn.

`ArrayList` hợp với `get` và `set` theo index. `LinkedList` hợp với hai đầu của một `Deque`, và index ở giữa phải đi từ đầu hoặc cuối gần hơn. Cả ba class `ArrayList`, `LinkedList` và `HashMap` đều ghi rõ chúng không synchronized. Đổi value có sẵn không bị tính là sửa cấu trúc. Thêm hoặc xóa thì có.

## References

- [Lesson: Introduction to Collections](https://docs.oracle.com/javase/tutorial/collections/intro/index.html)
- [Lesson: Interfaces](https://docs.oracle.com/javase/tutorial/collections/interfaces/index.html)
- [ArrayList (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/ArrayList.html)
- [LinkedList (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/LinkedList.html)
- [HashMap (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/HashMap.html)

## Series

- Previous: [Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế](../03-interface-and-abstract-class/index.md)
- Next: [Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure](../05-generics/index.md)
