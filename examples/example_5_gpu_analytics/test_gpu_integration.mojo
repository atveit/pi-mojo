from t2m_runtime import MetalClassifier, is_metal_available

def main() raises:
    print("=========================================================")
    print("Testing t2m_runtime GPU MetalClassifier Integration")
    print("=========================================================")
    
    if not is_metal_available():
        print("Apple Metal GPU is not available or interoperability libraries are missing. Skipping.")
        return
        
    print("Metal GPU: Available")
    
    var classifier = MetalClassifier()
    var json = String('{"data": [10, 20], "valid": true}')
    var result = classifier.classify(json)
    
    print("Input:  ", json)
    print("Output: ", end="")
    for i in range(len(result)):
        print(result[i], " ", end="")
    print()
    
    # Simple checks
    # '{' is code 1
    if result[0] != 1:
         raise Error("Incorrect classification for '{'")
    # '"' is code 5
    if result[1] != 5:
         raise Error("Incorrect classification for '\"'")
         
    print("GPU Integration: PASS")
    print("=========================================================\n")
