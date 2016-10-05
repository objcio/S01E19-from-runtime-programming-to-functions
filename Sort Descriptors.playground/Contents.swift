import Foundation

final class Person: NSObject {
    var first: String
    var last: String
    var yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
    }
}

var people = [
    Person(first: "Jo", last: "Smith", yearOfBirth: 1970),
    Person(first: "Joanne", last: "Williams", yearOfBirth: 1985),
    Person(first: "Annie", last: "Williams", yearOfBirth: 1985),
    Person(first: "Robert", last: "Jones", yearOfBirth: 1990),
]


let lastDescriptor = NSSortDescriptor(key: "last", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
let firstDescriptor = NSSortDescriptor(key: "first", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))

(people as NSArray).sortedArray(using: [lastDescriptor, firstDescriptor])



typealias SortDescriptor<A> = (A, A) -> Bool

func sortDescriptor<Value, Property>(property: @escaping (Value) -> Property, comparator: @escaping (Property) -> (Property) -> ComparisonResult) -> SortDescriptor<Value> {
    return { value1, value2 in
        comparator(property(value1))(property(value2)) == .orderedAscending
    }
}

func sortDescriptor<Value, Property>(property: @escaping (Value) -> Property) -> SortDescriptor<Value> where Property: Comparable {
    return { value1, value2 in
        property(value1) < property(value2)
    }
}

let lastName: SortDescriptor<Person> = sortDescriptor(property: { $0.last }, comparator: String.localizedCaseInsensitiveCompare)
let firstName: SortDescriptor<Person> = sortDescriptor(property: { $0.first }, comparator: String.localizedCaseInsensitiveCompare)

let yearOfBirth: SortDescriptor<Person> = sortDescriptor(property: { $0.yearOfBirth })


func combine<A>(sortDescriptors: [SortDescriptor<A>]) -> SortDescriptor<A> {
    return { lhs, rhs in
        for descriptor in sortDescriptors {
            if descriptor(lhs,rhs) { return true }
            if descriptor(rhs,lhs) { return false }
        }
        return false
    }
}

people.sort(by: combine(sortDescriptors: [lastName, firstName, yearOfBirth]))



