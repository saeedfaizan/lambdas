# Python
import unittest
from components.sample_component_1.lambdas.sample_lambda_1.src.dummy_class import DummyClass

class TestDummyClass(unittest.TestCase):
    def test_dummy_class_initialization(self):
        dummy = DummyClass(value=10)
        self.assertEqual(dummy.value, 10)

if __name__ == "__main__":
    unittest.main()