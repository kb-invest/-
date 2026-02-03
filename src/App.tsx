import { useState } from 'react'
import { Building2, FileText, Sparkles } from 'lucide-react'
import PropertyForm from './components/PropertyForm'
import PromptGuide from './components/PromptGuide'
import './App.css'

function App() {
  const [activeTab, setActiveTab] = useState<'form' | 'prompts'>('form')

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-blue-50 to-gray-100">
      {/* Header */}
      <header className="bg-luxury-darkblue text-white shadow-2xl">
        <div className="container mx-auto px-6 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Building2 size={40} className="text-luxury-gold" />
              <div>
                <h1 className="text-3xl font-bold tracking-tight">
                  상업용 부동산 제안서 생성 시스템
                </h1>
                <p className="text-gray-300 text-sm mt-1">
                  Professional Commercial Real Estate Proposal Generator
                </p>
              </div>
            </div>
            <div className="flex items-center space-x-2 bg-luxury-gold bg-opacity-20 px-4 py-2 rounded-lg">
              <Sparkles size={20} className="text-luxury-gold" />
              <span className="font-semibold">Premium Edition</span>
            </div>
          </div>
        </div>
      </header>

      {/* Navigation Tabs */}
      <div className="bg-white border-b border-gray-200 shadow-sm">
        <div className="container mx-auto px-6">
          <div className="flex space-x-8">
            <button
              onClick={() => setActiveTab('form')}
              className={`py-4 px-6 font-semibold transition-all duration-200 border-b-4 ${
                activeTab === 'form'
                  ? 'border-luxury-darkblue text-luxury-darkblue'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              <div className="flex items-center space-x-2">
                <FileText size={20} />
                <span>제안서 작성</span>
              </div>
            </button>
            <button
              onClick={() => setActiveTab('prompts')}
              className={`py-4 px-6 font-semibold transition-all duration-200 border-b-4 ${
                activeTab === 'prompts'
                  ? 'border-luxury-darkblue text-luxury-darkblue'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              <div className="flex items-center space-x-2">
                <Sparkles size={20} />
                <span>AI 프롬프트 가이드</span>
              </div>
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <main className="container mx-auto px-6 py-12">
        {activeTab === 'form' ? <PropertyForm /> : <PromptGuide />}
      </main>

      {/* Footer */}
      <footer className="bg-luxury-darkblue text-white py-8 mt-20">
        <div className="container mx-auto px-6 text-center">
          <p className="text-gray-300">
            © 2026 이음프로퍼티 부동산중개법인 | Developed by Rick
          </p>
          <p className="text-gray-400 text-sm mt-2">
            25년차 상업용 부동산 전문 중개사를 위한 프리미엄 솔루션
          </p>
        </div>
      </footer>
    </div>
  )
}

export default App
