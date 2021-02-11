import numpy as np

def alignStrings(startString, endString, insertCost, deleteCost, subCost):
    # Modify the strings and create a matrix of the corret size with np.inf for every cell.
    startString = "-" + startString
    endString = "-" + endString
    costMatrix = [[np.inf for y in range(len(endString))] for x in range(len(startString))]

    # For loop to update matrix to correct values.
    for y in range(len(costMatrix)):
        for x in range(len(endString)):
            # Variables to represent avaliable movement through the matrix.
            diagonal = costMatrix[y-1][x-1]
            diagonalPlusCost = diagonal + subCost
            topPlusCost = costMatrix[y-1][x] + deleteCost
            leftPlusCost = costMatrix[y][x-1] + insertCost

            # Populate first spot with 0 runs once.
            if endString[x] == "-" and startString[y] == "-":
                costMatrix[y][x] = 0
            # Populate the first x and y columns in the matrix.
            elif endString[x] == "-":
                costMatrix[y][x] = y * deleteCost
            elif endString == "-":
                costMatrix[y][x] = y * insertCost
            # Append the smallest value while taking into consideration if the diagonal is a no-op or a sub.
            elif endString[x] == startString[y]:
                costMatrix[y][x] = min(topPlusCost, leftPlusCost, diagonal)
            else:
                costMatrix[y][x] = min(topPlusCost, leftPlusCost, diagonalPlusCost)            
                # Top is the smallest.
                # if topPlusCost <= leftPlusCost and topPlusCost <= diagonalPlusCost:
                #     costMatrix[y][x] = topPlusCost

                # # Diagonal is the smallest.
                # elif diagonalPlusCost <= topPlusCost and diagonalPlusCost <= leftPlusCost:
                #     costMatrix[y][x] = diagonalPlusCost

                # # Left is the smallest.
                # elif leftPlusCost <= topPlusCost and leftPlusCost <= diagonalPlusCost:
                #     costMatrix[y][x] = leftPlusCost

    # print(np.matrix(costMatrix))
    return costMatrix

def extractAlignment(costMatrix, startString, endString, insertCost, deleteCost, subCost):
    # Modify the strings
    startString = "-" + startString
    endString = "-" + endString

    # Variables to track location and store results.
    # optimalOperationPathCoordinates = [[-1, -1]]
    # optimalOperationPathValue = [costMatrix[-1][-1]]
    optimalOperations = []
    currentLocationX = -1
    currentLocationY = -1

    # This function finds the optimal path from the bottom right corner to the top left corner. 
    while not (( startString[currentLocationX] == "-") and ( endString[currentLocationY] == "-")):
        # Catch out of bound errors.
        try:
            top = costMatrix[currentLocationX-1][currentLocationY]
        except:
            top = np.inf

        try:
            left = costMatrix[currentLocationX][currentLocationY-1]
        except:
            left = np.inf

        try:
            diagonal = costMatrix[currentLocationX-1][currentLocationY-1]
        except:
            diagonal = np.inf

        # Top is the smallest update and append accordingly.
        if top < left and top < diagonal:
            currentLocationX = currentLocationX-1
            currentLocationY = currentLocationY
            # optimalOperationPathCoordinates.append([currentLocationX,currentLocationY])
            # optimalOperationPathValue.append(costMatrix[currentLocationX][currentLocationY])
            optimalOperations.append("delete")

        # Diagonal is the smallest (no-op) update and append accordingly.
        elif diagonal <= top and diagonal <= left and diagonal == costMatrix[currentLocationX][currentLocationY]:
            currentLocationX = currentLocationX-1
            currentLocationY = currentLocationY-1
            # optimalOperationPathCoordinates.append([currentLocationX,currentLocationY])
            # optimalOperationPathValue.append(costMatrix[currentLocationX][currentLocationY])
            optimalOperations.append("no-op")

        # Diagonal is the smallest (sub) update and append accordingly.
        elif diagonal <= top and diagonal <= left and diagonal != costMatrix[currentLocationX][currentLocationY]:
            currentLocationX = currentLocationX-1
            currentLocationY = currentLocationY-1
            # optimalOperationPathCoordinates.append([currentLocationX,currentLocationY])
            # optimalOperationPathValue.append(costMatrix[currentLocationX][currentLocationY])
            optimalOperations.append("sub")

        # Left is the smallest update and append accordingly.
        elif left <= top and left <= diagonal:
            currentLocationX = currentLocationX
            currentLocationY = currentLocationY-1
            # optimalOperationPathCoordinates.append([currentLocationX,currentLocationY])
            # optimalOperationPathValue.append(costMatrix[currentLocationX][currentLocationY])
            optimalOperations.append("insert")
    
    # print(optimalOperationPathCoordinates)
    # print(optimalOperationPathValue)
    # print(optimalOperations[::-1])
    return optimalOperations[::-1]

def commonSubstrings(startString, minRepeat, optimalOperations):
    # Variables to track location and store results.
    startPointer = endPointer = tracker = skips = 0
    returnList = []

    # Check for L no-ops until the entire array is traversed.
    while startPointer < len(optimalOperations):
        # Handle inserts by adding skips.
        if optimalOperations[startPointer] == "insert":
            skips += 1
        # Handle if L no-ops are found.
        if optimalOperations[startPointer] == "no-op":
            endPointer = startPointer
            # Traverse the array updating "pointers" along the way. 
            # The 2nd condition is used to prevent out of index error.
            while endPointer < len(optimalOperations) and optimalOperations[endPointer] == "no-op":
                tracker += 1
                endPointer += 1
            # Append section into the result array.
            if tracker >= minRepeat:
                tempString = startString[startPointer - skips:endPointer - skips]
                returnList.append(str(len(tempString)) + ", " + str(tempString))
            # Update pointers and reset the tracker.
            startPointer = endPointer - 1
        startPointer += 1
        tracker = 0

    # print(returnList)
    return returnList

def partADriver():
    insertCost = 2 # 2
    deleteCost = 1 # 1
    subCost = 2 # 2
    minRepeat = 2
    startString = "BEAR" # 0-3
    endString = "BARE" # 0-3
    startString = "PLAIN" # 0-4
    endString = "PLANE" # 0-4
    startString = "FLOUR"
    endString = "FLOWER"
    startString = "AHIGHSTEP"
    endString = "HGIHAPE"
    startString = "EXPONENTIAL" # 0-11
    endString = "POLYNOMIAL" # 0-10

    costMatrix = alignStrings(startString, endString, insertCost, deleteCost, subCost)
    optimalOperations = extractAlignment(costMatrix, startString, endString, insertCost, deleteCost, subCost)
    commonStrings = commonSubstrings(startString, minRepeat, optimalOperations)
    print("--------------------------Part 1------------------------------")
    print(np.matrix(costMatrix))
    print(optimalOperations)
    print(commonStrings)

partADriver()