#!/bin/bash

echo "🧪 Testing contracts-kit package installation..."
echo "=================================================="

# Build the main package first
echo "📦 Building main contracts-kit package..."
npm install
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Failed to build main package"
    exit 1
fi

echo ""
echo "🔧 Testing TypeScript package..."
echo "================================"

# Test TypeScript package
cd test-typescript-project
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install TypeScript test dependencies"
    exit 1
fi

npm run build
if [ $? -ne 0 ]; then
    echo "❌ Failed to build TypeScript test project"
    exit 1
fi

echo ""
echo "Running TypeScript test..."
npm start

if [ $? -ne 0 ]; then
    echo "❌ TypeScript test failed"
    exit 1
fi

cd ..

echo ""
echo "🍎 Testing Swift package..."
echo "============================"

# Test Swift package
cd test-swift-project
swift build

if [ $? -ne 0 ]; then
    echo "❌ Failed to build Swift test project"
    exit 1
fi

echo ""
echo "Running Swift test..."
swift run TestContractsKit

if [ $? -ne 0 ]; then
    echo "❌ Swift test failed"
    exit 1
fi

cd ..

echo ""
echo "✅ All package tests completed successfully!"
echo "🎉 contracts-kit is ready for distribution!"
