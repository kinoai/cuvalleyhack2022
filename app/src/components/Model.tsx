import { Canvas } from '@react-three/fiber'
import { Environment } from '@react-three/drei'
import { Suspense } from 'react'
import BlenderModel from '../assets/BlenderModel'

function Model() {
  return (
        <Canvas>
          <Suspense fallback={null}>
            <BlenderModel position={[-1, -1, -2]} />
            <Environment preset="sunset" background />
          </Suspense>
        </Canvas>
  );
}

export default Model;