//
//  main.swift
//  sdfg
//
//  Created by Álvaro Santillan on 8/3/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

import Foundation

var fibNumbers = [Int]()
var rightFibArrayIndex = 0
var midFibArrayIndex = 0
var leftFibArrayIndex = 0
var rightTargetArrayPointer = 0
var midTargetArrayPointer = 0
var leftTargetArrayPointer = 0
var offset = 0
var targget = 0

func fibGenerator(left: Int, right: Int, target: Int) {
    if left == 0 {
        fibNumbers.append(left)
        fibNumbers.append(right)
        fibNumbers.append(right)
        fibGenerator(left: right, right: (left + right), target: target)
    } else {
        let nextNumber = left + right
        if nextNumber >= target {
            fibNumbers.append(nextNumber)
            return
        } else {
            fibNumbers.append(nextNumber)
            fibGenerator(left: right, right: nextNumber, target: target)
        }
    }
}

func fibMonaccianSearch(targetArray: [Int], target: Int, arraySize: Int) -> Int {
      
//    # Initialize fibonacci numbers
    var fibMMm2 = 0 //# (m-2)'th Fibonacci No.
    var fibMMm1 = 1 //# (m-1)'th Fibonacci No.
    var fibM = fibMMm2 + fibMMm1 //# m'th Fibonacci
  
//    # fibM is going to store the smallest
//    # Fibonacci Number greater than or equal to n
    while (fibM < arraySize) {
        fibMMm2 = fibMMm1
        fibMMm1 = fibM
        fibM = fibMMm2 + fibMMm1
    }
//    # Marks the eliminated range from front
    var offset = -1;
  
//    # while there are elements to be inspected.
//    # Note that we compare arr[fibMm2] with x.
//    # When fibM becomes 1, fibMm2 becomes 0
    while (fibM > 1) {
          
//        # Check if fibMm2 is a valid location
        let i = min(offset+fibMMm2, arraySize-1)
  
//        # If x is greater than the value at
//        # index fibMm2, cut the subarray array
//        # from offset to i
        if (targetArray[i] < target) {
            fibM = fibMMm1
            fibMMm1 = fibMMm2
            fibMMm2 = fibM - fibMMm1
            offset = i
        }
//        # If x is less than the value at
//        # index fibMm2, cut the subarray
//        # after i+1
        else if (targetArray[i] > target) {
            fibM = fibMMm2
            fibMMm1 = fibMMm1 - fibMMm2
            fibMMm2 = fibM - fibMMm1
        }
//        # element found. return index
        else {
            return i
        }
    }
    
//    # comparing the last element with x */
    if (fibMMm1 == 1 && targetArray[offset+1] == target) {
        return offset+1;
    }
//    # element not found. return -1
    return -1
}
  
//# Driver Code
//let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
//let n = arr.count
//let x = 17
//let result = fibMonaccianSearch(targetArray: arr, target: x, arraySize: n)
//print("Found at index:", result)
//print("test Complete")

var testArray = [Int]()

func tester() {
    for _ in 0...100 {
        testArray.removeAll()
        for _ in 0...Int.random(in: 5...50) {
            testArray.append(Int.random(in: 0...100))
        }
        testArray.sort()
//        print(testArray)
        rightFibArrayIndex = fibNumbers.count - 1
        midFibArrayIndex = rightFibArrayIndex - 1
        leftFibArrayIndex = midFibArrayIndex - 1
        rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
        midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
        leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
        offset = 0
        targget = -1
        for i in testArray {
            fibGenerator(left: 0, right: 1, target: testArray.count)
            rightFibArrayIndex = fibNumbers.count - 1
            midFibArrayIndex = rightFibArrayIndex - 1
            leftFibArrayIndex = midFibArrayIndex - 1
            rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
            midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
            leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
            offset = 0
            targget = -1
            let targetLocation = fibMonaccianSearch(targetArray: testArray, target: i, arraySize: testArray.count)
            if targetLocation == -1 {
                print(testArray)
                print("f1", i)
            } else if testArray[targetLocation] != i {
                print(testArray)
                print("f2", i)
            } else {
//                print("G1", i)
//                targetLocation = -1
            }
        }
    }
    print("test Complete")
}

tester()

//let array = [10,22,35,40,45,50,80,82,85,90,100]
//var fibNumbers = [Int]()
//
//func fibGenerator(left: Int, right: Int, target: Int) {
//    if left == 0 {
//        fibNumbers.append(left)
//        fibNumbers.append(right)
//        fibNumbers.append(right)
//        fibGenerator(left: right, right: (left + right), target: target)
//    } else {
//        let nextNumber = left + right
//        if nextNumber >= target {
//            fibNumbers.append(nextNumber)
//            return
//        } else {
//            fibNumbers.append(nextNumber)
//            fibGenerator(left: right, right: nextNumber, target: target)
//        }
//    }
//}
//
////fibGenerator(left: 0, right: 1, target: targetArray.count)
//var rightFibArrayIndex = 0
//var midFibArrayIndex = 0
//var leftFibArrayIndex = 0
//var rightTargetArrayPointer = 0
//var midTargetArrayPointer = 0
//var leftTargetArrayPointer = 0
//var offset = 0
//var targget = 0
//
//func fibonacciSearch(targetArray: [Float], target: Float) -> Int {
////    print(offset)
//    if (offset + leftTargetArrayPointer + 1) <= targetArray.count-1 {
//        if targetArray[offset + leftTargetArrayPointer + 1] == target {
//            targget = (offset + leftTargetArrayPointer + 1)
//            return targget
//        }
//    }
//    if (offset + leftTargetArrayPointer) >= targetArray.count {
//        if targetArray[offset + leftTargetArrayPointer] == target {
//            targget = (offset + leftTargetArrayPointer)
//            return targget
//        }
//    } else if midTargetArrayPointer == 0 {
////        if targetArray[offset + leftTargetArrayPointer + 1] == target {
////            targget = offset + leftTargetArrayPointer + 1
////            return targget
////        } else
//
//        if targetArray[midTargetArrayPointer] == target {
//            targget = midTargetArrayPointer
//            return targget
//        } else if targetArray[rightTargetArrayPointer] == target {
//            targget = rightTargetArrayPointer
//            return targget
//        } else {
//            return -1
//        }
//    } else if targetArray[offset + leftTargetArrayPointer] < target {
//        print("a", leftTargetArrayPointer, midTargetArrayPointer, rightTargetArrayPointer, targetArray[offset + leftTargetArrayPointer])
//        offset = offset + (leftTargetArrayPointer + 1)
//        rightFibArrayIndex = rightFibArrayIndex - 1
//        midFibArrayIndex = rightFibArrayIndex - 1
//        leftFibArrayIndex = midFibArrayIndex - 1
//        rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
//        midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
//        leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
//        if (offset + leftTargetArrayPointer + 1) >= targetArray.count {
//
//        } else {
//            print("new a", leftTargetArrayPointer, midTargetArrayPointer, rightTargetArrayPointer, targetArray[offset + leftTargetArrayPointer])
//        }
//        fibonacciSearch(targetArray: targetArray, target: target)
//    } else if targetArray[offset + leftTargetArrayPointer] > target {
//        print("b", leftTargetArrayPointer, midTargetArrayPointer, rightTargetArrayPointer, targetArray[offset + leftTargetArrayPointer])
//        rightFibArrayIndex = rightFibArrayIndex - 1
//        midFibArrayIndex = rightFibArrayIndex - 1
//        leftFibArrayIndex = midFibArrayIndex - 1
//        rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
//        midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
//        leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
//        print("new b", leftTargetArrayPointer, midTargetArrayPointer, rightTargetArrayPointer, targetArray[offset + leftTargetArrayPointer])
//        fibonacciSearch(targetArray: targetArray, target: target)
//    } else {
//        print("o no")
//    }
//    return targget
//}
//
////let teeest: [Float] = [0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15, 0.16, 0.17]
//////[0.001845479, 0.21600932, 0.31764108, 0.3203097, 0.39759362, 0.5435397, 0.6661316, 0.78086287, 0.84507495, 0.8677943, 0.8729306]
////fibGenerator(left: 0, right: 1, target: teeest.count)
////rightFibArrayIndex = fibNumbers.count - 1
////midFibArrayIndex = rightFibArrayIndex - 1
////leftFibArrayIndex = midFibArrayIndex - 1
////rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
////midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
////leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
////offset = 0
////targget = -1
////print(fibonacciSearch(targetArray: teeest, target: 0.17))
////print(fibonacciSearch(targetArray: teeest, target: 0.7))
//
//
//var testArray = [Float]()
//
//func tester() {
//    for _ in 0...100 {
//        testArray.removeAll()
//        for _ in 0...Int.random(in: 5...20) {
//            testArray.append(Float.random(in: 0...1))
//        }
//        testArray.sort()
//        fibGenerator(left: 0, right: 1, target: testArray.count)
//        rightFibArrayIndex = fibNumbers.count - 1
//        midFibArrayIndex = rightFibArrayIndex - 1
//        leftFibArrayIndex = midFibArrayIndex - 1
//        rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
//        midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
//        leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
//        offset = 0
//        targget = -1
////        print(testArray)
//        for i in testArray {
//            rightFibArrayIndex = fibNumbers.count - 1
//            midFibArrayIndex = rightFibArrayIndex - 1
//            leftFibArrayIndex = midFibArrayIndex - 1
//            rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
//            midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
//            leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
//            offset = 0
//            targget = -1
//            let targetLocation = fibonacciSearch(targetArray: testArray, target: i)
//            if targetLocation == -1 {
//                print(testArray)
//                print("f1", i)
//            } else if testArray[targetLocation] != i {
//                print(testArray)
//                print("f2", i)
//            } else {
////                print("G1", i)
////                targetLocation = -1
//            }
//        }
//    }
//    print("test Complete")
//}
//
//tester()
































//let array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
//let array = [0,1,1,2,3,5,8,13,21,34,55,77,89,91,95,110]
//var targetLocation = -1
//
//func jumpSort(targetArray: [Float], targetValue: Float) {
//    let jumpSize = (Int(ceil(sqrt(Float(targetArray.count)))) - 1)
////    print("jump Size", jumpSize)
//    var currentJumpLocation = 0
//    var nextJumpLocation = (currentJumpLocation + jumpSize)
//    var currentJumpLocationValue = targetArray[currentJumpLocation]
//    var nextJumpLocationValue = targetArray[nextJumpLocation]
//    var found = false
//
////    print("explored", currentJumpLocationValue)
//    if currentJumpLocationValue == targetValue {
//        found = true
//        targetLocation = currentJumpLocation
////        print(targetLocation)
//    }
//
//    while found != true {
////        print("explored", nextJumpLocationValue)
//        if nextJumpLocationValue == targetValue {
//            found = true
//            targetLocation = nextJumpLocation
////            print(targetLocation)
//        }
////        print("explored", nextJumpLocationValue)
//        if nextJumpLocationValue > targetValue || nextJumpLocation >= targetArray.count {
//            for i in currentJumpLocation...(nextJumpLocation-1) {
////                print("explored", targetArray[i])
//                if targetArray[i] == targetValue {
//                    found = true
//                    targetLocation = i
////                    print(targetLocation)
//                    break
//                }
//            }
//            break
//        }
////        print("explored", nextJumpLocationValue)
//        if nextJumpLocationValue < targetValue {
//            if (nextJumpLocation + jumpSize) >= targetArray.count {
//                for i in nextJumpLocation...(targetArray.count-1) {
////                    print("explored", targetArray[i])
//                    if targetArray[i] == targetValue {
//                        found = true
//                        targetLocation = i
////                        print(targetLocation)
//                        break
//                    }
//                }
//                break
//            }
//            currentJumpLocation = nextJumpLocation
//            currentJumpLocationValue = targetArray[currentJumpLocation]
//            nextJumpLocation = (currentJumpLocation + jumpSize)
//            nextJumpLocationValue = targetArray[nextJumpLocation]
//        }
//    }
//
//    if found == false {
//        targetLocation = -1
//        print(targetLocation)
//    }
//}

//let errorArray: [Float] = [0.010392845, 0.027471066, 0.10481888, 0.32723218, 0.4823702, 0.5795634, 0.644578, 0.769306]
//jumpSort(targetArray: errorArray, targetValue: 0.769306)
//
//var testArray = [Float]()
//
//func tester() {
//    for _ in 0...1000 {
//        for _ in 0...Int.random(in: 1...100) {
//            testArray.append(Float.random(in: 0...100))
//        }
//        testArray.sort()
////        print(testArray)
//        for i in testArray {
//            jumpSort(targetArray: testArray, targetValue: i)
//            if targetLocation == -1 {
//                print(testArray)
//                print("f1", i)
//            } else if testArray[targetLocation] != i {
//                print(testArray)
//                print("f2", i)
//            } else {
//    //            print("Good")
//                targetLocation = -1
//            }
//        }
//    }
//    print("test Complete")
//}
//
//tester()

// run on diffrent array sizes




//func quickSort(targetArray: [Int], frontPointer: Int, endPointer: Int) {
//    array = targetArray
//
//    if frontPointer == endPointer {
//        return
//    } else if endPointer < frontPointer {
//        return
//    }
//
//    let pivot = array[endPointer]
//    var jIndex = frontPointer
//    var iIndex = frontPointer-1
//
//    for _ in (frontPointer...(endPointer-1)) {
//        if jIndex < (array.count-1) {
//            if array[jIndex] < pivot {
//                iIndex += 1
//                let tempIValue = array[iIndex]
//                array[iIndex] = array[jIndex]
//                array[jIndex] = tempIValue
//            }
//            jIndex += 1
//        }
//    }
//    let finalPivotLocation = array[iIndex+1]
//    array[iIndex+1] = pivot
//    array[endPointer] = finalPivotLocation
//
//    if (endPointer - 1 != frontPointer) {
//        quickSort(targetArray: array, frontPointer: frontPointer, endPointer: iIndex)
//        quickSort(targetArray: array, frontPointer: iIndex+2, endPointer: endPointer)
//    }
//}
//
//var array = [1,9,2,5,4, 8,3,5,0,9, 8,1,4,1,2, 3,4,5,6,3, 2]
//
//func medianOfMedians(frontPointer: Int, endPointer: Int) -> Int {
//
//    if (endPointer - frontPointer) < 5 {
//        quickSort(targetArray: array, frontPointer: frontPointer, endPointer: endPointer)
//        let median = Int(ceil((Float(endPointer) - Float(frontPointer))/2))
//        print(array[median])
//        return median
//    }
//
//    var medians = [Int]()
//    var lastChunckEnd = frontPointer
//
//    while (lastChunckEnd + 4) < endPointer {
//        let currentChunkEnd = lastChunckEnd + 4
//        quickSort(targetArray: array, frontPointer: lastChunckEnd, endPointer: currentChunkEnd)
//        medians.append(array[lastChunckEnd+2])
//        lastChunckEnd = currentChunkEnd+1
//    }
//
//
//    quickSort(targetArray: medians, frontPointer: 0, endPointer: medians.count-1)
//
//    print(medians)
//    print(array)
//    print(array[Int(ceil(Float(medians.count)/2))])
//    return medians[Int(ceil(Float(medians.count)/2))]
//}
//
//medianOfMedians(frontPointer: 0, endPointer: 3)

//var testArray = [Float]()
////for _ in 0 ... 5 {
//    for _ in 0...6 {
//        testArray.append(Float.random(in: 0 ... 1))
//    }
//    print(testArray)
//    quickSort(targetArray: testArray, frontPointer: 0, endPointer: testArray.count-1)
//    let varifiedSortedTest = testArray.sorted()
//    if array != varifiedSortedTest {
//        print("failed")
//        print("original", testArray)
//        print("varified", varifiedSortedTest)
//        print("array", array)
//    }
////}
//print("Finished")
