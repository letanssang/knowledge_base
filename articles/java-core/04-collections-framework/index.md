---
title: "Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue"
description: "Một interface cho mỗi việc: List có thứ tự, Set không trùng, Map ánh xạ key, Queue giữ phần tử chờ xử lý. ArrayList, LinkedList và HashMap không synchronized."

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

> **Tóm tắt:** Mình chọn interface theo việc cần làm, rồi mới chọn class. `Map` không phải `Collection`. `ArrayList` lấy phần tử theo chỉ số trong thời gian hằng. `LinkedList` đi từ đầu hoặc cuối khi cần một chỉ số. `HashMap` không giữ thứ tự chèn và cho phép một key `null`.

*Thời gian đọc: ~10 phút*

---

## 1. Vì sao không tự viết danh sách

Một tay bài, một hộp thư, một danh bạ tên sang số: đều là nhiều phần tử gom vào một object. Collection là object đó. Mình dùng nó để cất, lấy, sửa và đưa cả nhóm đi.

Nếu mỗi thư viện tự nghĩ một danh sách riêng, chỗ này trả tên node, chỗ kia đòi tiêu đề cột, mình phải viết lớp chuyển ở giữa. Collections Framework cho một bộ từ vựng chung. Nó có ba phần:

- Interface mô tả việc, không mô tả cách cất trong RAM. Nhờ vậy mình đổi class bên dưới mà code gọi interface không đổi.
- Implementation là cấu trúc dữ liệu làm việc đó.
- Algorithm là method như tìm và sắp xếp, viết một lần rồi chạy trên nhiều implementation của cùng interface.

API mới nhận hoặc trả một collection thì dùng interface này, không bịa một bộ method riêng. Cấu trúc mới mà theo interface thì chỗ khác dùng lại được.

---

## 2. Hai cây, và Map đứng riêng

Có hai cây. `Set` là một `Collection`. `SortedSet` là một `Set`. `Map` không phải `Collection`. `SortedMap` là bản đã sắp của `Map`.

Mọi interface này đều generic. `Collection<E>` nghĩa là mình nói rõ phần tử là kiểu gì. Compiler kiểm lúc biên dịch, nên ít khi đến lúc chạy mới phát hiện mình vừa nhét nhầm kiểu.

Thao tác sửa được đánh dấu optional để không phải có một interface cho danh sách không sửa được, một interface cho danh sách cố định kích thước, một interface cho danh sách chỉ được thêm cuối. Implementation không hỗ trợ thao tác đó thì ném `UnsupportedOperationException`. Các implementation thông dụng của JDK hỗ trợ hết các thao tác optional.

| Interface | Mình dùng khi |
| --- | --- |
| `Collection` | Chỉ cần "một nhóm phần tử". JDK không có class implement thẳng interface này. |
| `Set` | Không được trùng. Như tập hợp trong toán. |
| `List` | Có thứ tự, được trùng, lấy được theo chỉ số. |
| `Queue` | Giữ phần tử trước khi xử lý. Thường vào trước ra trước, nhưng không phải queue nào cũng vậy. Priority queue xếp theo comparator hoặc theo thứ tự tự nhiên của phần tử. Phần tử đầu là phần tử `remove` hoặc `poll` sẽ lấy. Mỗi class phải nói rõ nó xếp thế nào. |
| `Deque` | Lấy và thêm được cả hai đầu, nên dùng như hàng đợi hoặc như stack. |
| `SortedSet`, `SortedMap` | Giữ phần tử hoặc key theo thứ tự tăng. |

---

## 3. ArrayList và LinkedList không đổi cho nhau được

`ArrayList` là `List` cất trong một mảng co giãn. Nó nhận `null`. Nó gần `Vector`, nhưng không khóa khi nhiều thread cùng đụng.

`get`, `set`, `size`, `isEmpty`, `getFirst`, `getLast`, `removeLast`, `iterator`, `listIterator` và `reversed` chạy trong thời gian hằng. `add` và `addLast` thêm một phần tử cũng vậy nếu tính trung bình. Thêm n phần tử thì hết O(n). Các việc còn lại đi hết danh sách, nhưng hệ số nhỏ hơn `LinkedList`.

Capacity là độ dài mảng bên trong, luôn ít nhất bằng số phần tử. Thêm phần tử thì mảng tự dài ra. JDK không mô tả mảng nhân lên bao nhiêu, chỉ đảm bảo thêm một phần tử có chi phí trung bình là hằng. `new ArrayList()` bắt đầu với capacity 10. Sắp thêm rất nhiều phần tử thì `ensureCapacity` xin một lần, đỡ cấp phát nhiều lần. `trimToSize` cắt mảng xuống đúng số phần tử. `clone` chỉ chép danh sách, không chép từng object bên trong.

`get` ném `IndexOutOfBoundsException` khi chỉ số âm hoặc không nhỏ hơn size. `getFirst` và `getLast` có từ Java SE 21. Danh sách rỗng thì chúng ném `NoSuchElementException`.

`LinkedList` là danh sách liên kết đôi, vừa là `List` vừa là `Deque`, và cũng nhận `null`. Lấy theo chỉ số thì nó đi từ đầu hoặc từ cuối, chọn đầu nào gần hơn. Đó là lý do chỉ số ở giữa danh sách dài thì `ArrayList` rẻ hơn.

Cả hai class không synchronized. Nhiều thread cùng dùng, và có thread thêm hoặc xóa phần tử, thì mình phải khóa từ bên ngoài. Chỉ gán đè một ô đã có thì `ArrayList` không tính là sửa cấu trúc. `LinkedList` cũng vậy: thêm hoặc xóa mới là sửa cấu trúc, gán giá trị một ô thì không. Không có object nào tự nhiên bao danh sách thì bọc bằng `Collections.synchronizedList`.

`LinkedList` còn là hàng đợi. `peek` và `poll` trả `null` khi rỗng. `element` và `remove()` ném `NoSuchElementException` khi rỗng. `addLast` chính là `add`.

---

## 4. HashMap là bảng băm, không phải danh sách đã xếp

`HashMap` làm mọi thao tác của `Map`, nhận `null` cho value và nhận một key `null`. Nó gần `Hashtable`, nhưng không khóa và cho phép null. Không có thứ tự. Thứ tự mình thấy lúc in cũng không được hứa là sẽ giữ nguyên.

`get` và `put` chạy trong thời gian hằng nếu `hashCode` rải key đều vào các bucket. Duyệt `keySet` thì tốn tỷ lệ với số bucket cộng với số cặp key-value. Capacity khởi tạo quá lớn, hoặc load factor quá nhỏ, làm vòng lặp này chậm.

Capacity là số bucket. Load factor là ngưỡng đầy trước khi bảng tự lớn. Số cặp vượt quá load factor nhân capacity thì bảng được dựng lại, số bucket khoảng gấp đôi. Load factor mặc định `0.75` cân thời gian và bộ nhớ. Tăng nó thì đỡ tốn bộ nhớ nhưng `get` và `put` đắt hơn. `new HashMap()` bắt đầu với 16 bucket và load factor `0.75`. Capacity âm, hoặc load factor không dương, thì constructor ném `IllegalArgumentException`. Nếu capacity ban đầu lớn hơn số cặp tối đa chia cho load factor, bảng không phải dựng lại lần nào.

Nhiều key cùng `hashCode` làm mọi bảng băm chậm. Key nào là `Comparable` thì `HashMap` có thể dùng thứ tự so sánh để gỡ các key đụng nhau.

`get` trả value, hoặc `null` khi không có key. Key `null` so bằng `==`. Key khác so bằng `equals`. `null` trả về chưa chắc là key không có, vì value cũng được phép là `null`. `containsKey` phân biệt hai trường hợp.

Class này không synchronized. Thêm hoặc xóa cặp là sửa cấu trúc và phải khóa ngoài nếu nhiều thread cùng làm. Đổi value của key đã có thì không phải sửa cấu trúc. Không có object bao map thì dùng `Collections.synchronizedMap`.

`keySet` là cửa sổ nhìn vào map. Sửa map thì set đổi, sửa set thì map đổi. Sửa map trong lúc đang duyệt set, trừ `remove` của chính iterator, thì kết quả duyệt không xác định. Set này không có `add`.

---

## Kết luận

Mình chọn interface trước. Cần chỉ số và thứ tự thì `List`. Cần không trùng thì `Set`. Cần key thì `Map`, và không chờ `HashMap` giữ thứ tự mình đã `put`. Cần hàng đợi thì đọc class đó xếp đầu hàng thế nào, vì FIFO không phải luật của mọi `Queue`.

Trong `List`, `get` và `set` theo chỉ số thì `ArrayList`. Thêm và lấy ở hai đầu thì `LinkedList`. Cả `ArrayList`, `LinkedList` và `HashMap` đều không tự khóa. Thêm hoặc xóa từ nhiều thread thì khóa ngoài, hoặc bọc bằng method `synchronized` của `Collections`.

## References

- [Lesson: Introduction to Collections](https://docs.oracle.com/javase/tutorial/collections/intro/index.html)
- [Lesson: Interfaces](https://docs.oracle.com/javase/tutorial/collections/interfaces/index.html)
- [ArrayList (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/ArrayList.html)
- [LinkedList (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/LinkedList.html)
- [HashMap (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/HashMap.html)

## Series

- Previous: [Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế](../03-interface-and-abstract-class/index.md)
- Next: [Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure](../05-generics/index.md)
