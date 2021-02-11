//
//  fibonacciSearch.swift
//  Sort N Search
//
//  Created by Álvaro Santillan on 8/14/20.
//  Copyright © 2020 Álvaro Santillan. All rights reserved.
//

// BROKEN

import Foundation

let array = [10,22,35,40,45,50,80,82,85,90,100]
var fibNumbers = [Int]()

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

//fibGenerator(left: 0, right: 1, target: array.count)
var rightFibArrayIndex = fibNumbers.count - 1
var midFibArrayIndex = rightFibArrayIndex - 1
var leftFibArrayIndex = midFibArrayIndex - 1
var rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
var midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
var leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
var offset = 0
var targget = -1

func fibonacciSearch(target: Int) -> Int {
    if array[offset + leftTargetArrayPointer] == target {
        targget = array[offset + leftTargetArrayPointer]
        return targget
    } else if midTargetArrayPointer == 1 {
        if array[midTargetArrayPointer] == target {
            targget = array[midTargetArrayPointer]
            return targget
        } else {
            return -1
        }
    } else if array[offset + leftTargetArrayPointer] < target {
        print("a", array[offset + leftTargetArrayPointer])
        offset = offset + (leftTargetArrayPointer + 1)
        rightFibArrayIndex = rightFibArrayIndex - 1
        midFibArrayIndex = rightFibArrayIndex - 1
        leftFibArrayIndex = midFibArrayIndex - 1
        rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
        midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
        leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
        print("new a", array[offset + leftTargetArrayPointer])
        fibonacciSearch(target: target)
    } else {
        print("b", array[offset + leftTargetArrayPointer])
        rightFibArrayIndex = rightFibArrayIndex - 1
        midFibArrayIndex = rightFibArrayIndex - 1
        leftFibArrayIndex = midFibArrayIndex - 1
        rightTargetArrayPointer = fibNumbers[rightFibArrayIndex] - 1
        midTargetArrayPointer = fibNumbers[midFibArrayIndex] - 1
        leftTargetArrayPointer = fibNumbers[leftFibArrayIndex] - 1
        print("new b", array[offset + leftTargetArrayPointer])
        fibonacciSearch(target: target)
    }
    return targget
}

//print(fibonacciSearch(target: 10))
